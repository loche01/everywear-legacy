package Security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordHasher {
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String PREFIX = "PBKDF2$";
    private static final int ITERATIONS = 600_000;
    private static final int SALT_BYTES = 16;
    private static final int KEY_BYTES = 32;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final Base64.Encoder ENCODER = Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder DECODER = Base64.getUrlDecoder();

    private PasswordHasher() {
    }

    public static String hash(String password) {
        if (password == null) {
            throw new IllegalArgumentException("Password is required.");
        }
        char[] chars = password.toCharArray();
        try {
            return hash(chars);
        } finally {
            Arrays.fill(chars, '\0');
        }
    }

    public static String hash(char[] password) {
        if (password == null) {
            throw new IllegalArgumentException("Password is required.");
        }
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] derived = derive(password, salt, ITERATIONS);
        try {
            return PREFIX + ITERATIONS + "$" + ENCODER.encodeToString(salt)
                    + "$" + ENCODER.encodeToString(derived);
        } finally {
            Arrays.fill(salt, (byte) 0);
            Arrays.fill(derived, (byte) 0);
        }
    }

    public static boolean verify(String password, String storedPassword) {
        if (password == null) {
            return false;
        }
        char[] chars = password.toCharArray();
        try {
            return verify(chars, storedPassword);
        } finally {
            Arrays.fill(chars, '\0');
        }
    }

    public static boolean verify(char[] password, String storedPassword) {
        if (password == null || storedPassword == null) {
            return false;
        }
        if (!storedPassword.startsWith(PREFIX)) {
            return verifyLegacy(password, storedPassword);
        }

        String[] parts = storedPassword.split("\\$", -1);
        if (parts.length != 4 || !"PBKDF2".equals(parts[0])
                || !parts[2].matches("[A-Za-z0-9_-]{22}")
                || !parts[3].matches("[A-Za-z0-9_-]{43}")) {
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[1]);
            if (iterations != ITERATIONS) {
                return false;
            }
            byte[] salt = DECODER.decode(parts[2]);
            byte[] expected = DECODER.decode(parts[3]);
            if (salt.length != SALT_BYTES || expected.length != KEY_BYTES) {
                return false;
            }
            byte[] actual = derive(password, salt, iterations);
            try {
                return MessageDigest.isEqual(expected, actual);
            } finally {
                Arrays.fill(salt, (byte) 0);
                Arrays.fill(expected, (byte) 0);
                Arrays.fill(actual, (byte) 0);
            }
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static boolean isEncoded(String storedPassword) {
        if (storedPassword == null || !storedPassword.startsWith(PREFIX)) {
            return false;
        }
        String[] parts = storedPassword.split("\\$", -1);
        if (parts.length != 4 || !"PBKDF2".equals(parts[0])
                || !parts[2].matches("[A-Za-z0-9_-]{22}")
                || !parts[3].matches("[A-Za-z0-9_-]{43}")) {
            return false;
        }
        try {
            int iterations = Integer.parseInt(parts[1]);
            return iterations == ITERATIONS
                    && DECODER.decode(parts[2]).length == SALT_BYTES
                    && DECODER.decode(parts[3]).length == KEY_BYTES;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static boolean verifyLegacy(char[] password, String storedPassword) {
        if (password == null || storedPassword == null || storedPassword.startsWith(PREFIX)) {
            return false;
        }
        byte[] actual = new String(password).getBytes(StandardCharsets.UTF_8);
        byte[] expected = storedPassword.getBytes(StandardCharsets.UTF_8);
        try {
            return MessageDigest.isEqual(expected, actual);
        } finally {
            Arrays.fill(actual, (byte) 0);
            Arrays.fill(expected, (byte) 0);
        }
    }

    private static byte[] derive(char[] password, byte[] salt, int iterations) {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, KEY_BYTES * 8);
        try {
            return SecretKeyFactory.getInstance(ALGORITHM).generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("PBKDF2 password hashing is unavailable.", e);
        } finally {
            spec.clearPassword();
        }
    }
}
