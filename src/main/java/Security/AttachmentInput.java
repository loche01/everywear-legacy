package Security;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import com.oreilly.servlet.multipart.*;

/** Bounded in-memory multipart parsing; this class never writes during parsing. */
public final class AttachmentInput {
    public final Map<String,String> fields = new HashMap<>();
    public byte[] image;
    private String extension;
    public static AttachmentInput read(HttpServletRequest request) throws IOException {
        if (!UserRequestGuard.authenticated(request.getSession(false)) || !UserRequestGuard.validToken(request))
            throw new IOException("Request unavailable.");
        AttachmentInput input = new AttachmentInput();
        MultipartParser parser = new MultipartParser(request, 5 * 1024 * 1024, true, true, "UTF-8");
        Set<String> names = new HashSet<>();
        com.oreilly.servlet.multipart.Part part;
        while ((part=parser.readNextPart())!=null) {
            if (!names.add(part.getName()) || !Set.of("title","content","private","i_id","p_id","file","removeImage").contains(part.getName()))
                throw new IOException("Invalid form.");
            if (part.isParam()) input.fields.put(part.getName(), ((ParamPart)part).getStringValue("UTF-8"));
            else {
                FilePart file=(FilePart)part;
                byte[] bytes=file.getInputStream().readNBytes(5*1024*1024+1);
                if(bytes.length>5*1024*1024)throw new IOException("Attachment too large.");
                if(file.getFileName()==null || bytes.length==0)continue;
                if(!"file".equals(part.getName()))throw new IOException("Invalid attachment.");
                String name=file.getFileName();
                if(name.contains("/")||name.contains("\\")||name.indexOf('.')<0)throw new IOException("Invalid attachment.");
                String ext=name.substring(name.lastIndexOf('.')+1).toLowerCase(Locale.ROOT);
                if(!Set.of("jpg","jpeg","png","gif").contains(ext))throw new IOException("Invalid attachment.");
                try(var stream=javax.imageio.ImageIO.createImageInputStream(new ByteArrayInputStream(bytes))) {
                    var readers=javax.imageio.ImageIO.getImageReaders(stream);
                    if(!readers.hasNext())throw new IOException("Invalid image.");
                    var reader=readers.next();
                    try{reader.setInput(stream);String format=reader.getFormatName().toLowerCase(Locale.ROOT);
                        if(!(format.equals(ext)||(format.equals("jpeg")&&ext.equals("jpg"))) || (long)reader.getWidth(0)*reader.getHeight(0)>25000000L)
                            throw new IOException("Invalid image.");
                    }finally{reader.dispose();}
                }
                input.image=bytes;input.extension=ext;
            }
        }
        return input;
    }
    public String save(Path directory) throws IOException {
        if(image==null)return null;
        Files.createDirectories(directory);
        String name=UUID.randomUUID()+"."+extension;
        Path file=directory.resolve(name);
        try{Files.write(file,image,StandardOpenOption.CREATE_NEW);}
        catch(IOException error){Files.deleteIfExists(file);throw error;}
        return name;
    }
    public static Path directory(HttpServletRequest request,String folder) throws IOException {
        String real=request.getServletContext().getRealPath("/"+folder);
        if(real==null)throw new IOException("Attachment storage unavailable.");
        return Path.of(real).toAbsolutePath().normalize();
    }
    public static void remove(Path directory,String name) {
        if(name==null||name.isBlank())return;
        Path file=directory.resolve(name).normalize();
        if(!file.getParent().equals(directory)||Files.isSymbolicLink(file))return;
        try{Files.deleteIfExists(file);}catch(IOException error){System.err.println("Attachment cleanup pending.");}
    }
}
