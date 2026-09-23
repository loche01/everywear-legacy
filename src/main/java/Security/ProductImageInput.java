package Security;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.awt.image.BufferedImage;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

/**
 * 관리자 상품 이미지 업로드 전용 검증/저장 helper.
 *
 * Q&A/리뷰 첨부는 {@code Security.AttachmentInput} 이 담당하고, 여기서는 상품 등록(insert) 업로드만 대상으로 한다.
 *
 * 원칙:
 * - client 파일명/확장자/Content-Type 을 전혀 신뢰하지 않는다.
 * - {@link ImageIO} 로 실제 이미지를 decode 해 포맷을 확인한다.
 * - 저장 확장자는 decode 결과에서만 결정한다(jpg/png/gif).
 * - 저장명은 서버가 만든 {@link UUID} 기반이라 경로 이탈/실행 확장자 생성이 불가능하다.
 * - 크기/픽셀/개수 상한을 강제한다.
 * - JSP/PHP/SVG/HTML/이중확장자/비이미지 는 decode 단계에서 모두 거부된다.
 */
public final class ProductImageInput {

    /** 파일 1개당 최대 바이트. */
    public static final int MAX_BYTES = 10 * 1024 * 1024;
    /** 이미지 픽셀(가로*세로) 상한. */
    public static final long MAX_PIXELS = 25_000_000L;
    /** 요청 1건에서 허용하는 이미지 총 개수(대표 1 + 상세). */
    public static final int MAX_FILES = 10;

    /** decode 포맷 -> 저장 확장자. 이 map 에 없는 포맷은 거부. */
    private static final Map<String, String> FORMAT_TO_EXT = Map.of(
            "jpeg", "jpg",
            "jpg", "jpg",
            "png", "png",
            "gif", "gif");

    private ProductImageInput() {
    }

    /** 검증을 통과한 이미지 1개(원본 바이트 + 서버가 결정한 확장자). */
    public static final class Image {
        public final byte[] data;
        public final String ext;

        private Image(byte[] data, String ext) {
            this.data = data;
            this.ext = ext;
        }
    }

    /**
     * 파트 1개를 실제 이미지로 검증한다.
     *
     * @return 검증된 이미지. 파일 입력이 비어 있으면 {@code null}(무시 대상).
     * @throws IOException 크기 초과 / 이미지 아님 / 허용되지 않는 포맷 / 픽셀 초과.
     */
    public static Image validate(Part part) throws IOException {
        if (part == null) {
            return null;
        }
        long declared = part.getSize();
        if (declared <= 0) {
            return null;
        }
        if (declared > MAX_BYTES) {
            throw new IOException("이미지 파일 크기가 허용 범위를 초과했습니다.");
        }

        byte[] bytes;
        try (InputStream in = part.getInputStream()) {
            bytes = in.readNBytes(MAX_BYTES + 1);
        }
        if (bytes.length == 0) {
            return null;
        }
        if (bytes.length > MAX_BYTES) {
            throw new IOException("이미지 파일 크기가 허용 범위를 초과했습니다.");
        }

        try (ImageInputStream iis = ImageIO.createImageInputStream(new ByteArrayInputStream(bytes))) {
            if (iis == null) {
                throw new IOException("이미지 파일을 읽을 수 없습니다.");
            }
            Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
            if (!readers.hasNext()) {
                throw new IOException("이미지 형식이 아닙니다.");
            }
            ImageReader reader = readers.next();
            try {
                String format;
                int width;
                int height;
                try {
                    reader.setInput(iis, true, true);
                    format = reader.getFormatName().toLowerCase(Locale.ROOT);
                    width = reader.getWidth(0);
                    height = reader.getHeight(0);
                } catch (IOException | RuntimeException decodeError) {
                    // ImageIO 내부 오류(손상/위조 파일 등)는 내부 메시지를 노출하지 않는다.
                    throw new IOException("이미지 파일을 읽을 수 없습니다.");
                }
                String ext = FORMAT_TO_EXT.get(format);
                if (ext == null) {
                    throw new IOException("허용되지 않는 이미지 형식입니다.");
                }
                if (width <= 0 || height <= 0 || (long) width * height > MAX_PIXELS) {
                    throw new IOException("이미지 크기가 허용 범위를 벗어났습니다.");
                }
                // 헤더만 정상인 손상 파일도 거부한다. 상한 확인 후 첫 이미지의 픽셀을 읽는다.
                BufferedImage decoded = null;
                boolean[] decodeWarning = {false};
                reader.addIIOReadWarningListener((source, warning) -> decodeWarning[0] = true);
                try {
                    decoded = reader.read(0);
                    if (decoded == null || decodeWarning[0]) {
                        throw new IOException("이미지 파일을 읽을 수 없습니다.");
                    }
                } catch (IOException | RuntimeException decodeError) {
                    throw new IOException("이미지 파일을 읽을 수 없습니다.");
                } finally {
                    if (decoded != null) {
                        decoded.flush();
                    }
                }
                return new Image(bytes, ext);
            } finally {
                reader.dispose();
            }
        }
    }

    /**
     * 검증된 이미지를 저장한다. 저장명은 {@code base + "_" + UUID + "." + ext} 이며
     * ext 는 {@code jpg|png|gif} 로 제한되므로 실행 가능한 확장자가 생성되지 않는다.
     *
     * @return 저장된 파일명(디렉터리 제외).
     */
    public static String save(Image image, Path directory, String base) throws IOException {
        if (image == null) {
            return null;
        }
        Path dir = directory.toAbsolutePath().normalize();
        Files.createDirectories(dir);
        String safeBase = (base == null ? "img" : base).replaceAll("[^A-Za-z0-9_-]", "");
        if (safeBase.isEmpty()) {
            safeBase = "img";
        }
        String name = safeBase + "_" + UUID.randomUUID() + "." + image.ext;
        Path file = dir.resolve(name).normalize();
        if (!dir.equals(file.getParent())) {
            throw new IOException("잘못된 저장 경로입니다.");
        }
        boolean created = false;
        try {
            try (OutputStream out = Files.newOutputStream(file, StandardOpenOption.CREATE_NEW)) {
                created = true;
                out.write(image.data);
            }
        } catch (IOException | RuntimeException writeError) {
            // CREATE_NEW 실패 시 기존 파일은 건드리지 않는다. 이번 호출이 생성한 파일만 정리한다.
            if (created) {
                try {
                    Files.deleteIfExists(file);
                } catch (IOException | RuntimeException cleanupError) {
                    writeError.addSuppressed(cleanupError);
                }
            }
            throw writeError;
        }
        return name;
    }

    /** 웹 접근 디렉터리의 정규화된 실제 경로. */
    public static Path webDir(HttpServletRequest request, String folder) throws IOException {
        String real = request.getServletContext().getRealPath("/" + folder);
        if (real == null) {
            throw new IOException("업로드 저장소를 사용할 수 없습니다.");
        }
        return Path.of(real).toAbsolutePath().normalize();
    }

    /**
     * 저장 디렉터리 안의 파일 1개를 안전하게 삭제한다.
     * 디렉터리 밖을 가리키거나 심볼릭 링크면 아무것도 하지 않는다.
     */
    public static void remove(Path directory, String name) {
        if (name == null || name.isBlank()) {
            return;
        }
        Path dir = directory.toAbsolutePath().normalize();
        Path file = dir.resolve(name).normalize();
        if (!dir.equals(file.getParent()) || Files.isSymbolicLink(file)) {
            return;
        }
        try {
            Files.deleteIfExists(file);
        } catch (IOException error) {
            System.err.println("상품 이미지 파일 정리 실패: " + name);
        }
    }

    /** DB 에 저장된 pi_url(예: {@code uploads/products/foo.png})에서 파일명만 추출. */
    public static String fileNameFromUrl(String url) {
        if (url == null) {
            return null;
        }
        String trimmed = url.replace('\\', '/');
        int slash = trimmed.lastIndexOf('/');
        String name = slash >= 0 ? trimmed.substring(slash + 1) : trimmed;
        return name.isBlank() ? null : name;
    }

    /** 허용 저장 확장자 집합(테스트/검증용). */
    public static Set<String> allowedExtensions() {
        return Set.of("jpg", "png", "gif");
    }
}
