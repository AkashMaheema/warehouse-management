// 1. First, let's create a utility class for security functions

package com.warehouse.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.regex.Pattern;

public class SecurityUtils {

    // Pattern to check if username contains only numbers
    private static final Pattern NUMBERS_ONLY = Pattern.compile("^[0-9]+$");

    // Pattern to validate username (allows letters, numbers, underscore, hyphen, minimum 3 chars)
    private static final Pattern VALID_USERNAME = Pattern.compile("^[a-zA-Z0-9_-]{3,20}$");

    /**
     * Validates a username
     * @param username The username to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        // Check if username is not numbers-only
        if (NUMBERS_ONLY.matcher(username).matches()) {
            return false;
        }

        // Check if username meets pattern requirements
        return VALID_USERNAME.matcher(username).matches();
    }

    /**
     * Hash a password using SHA-256 with salt
     * @param password The password to hash
     * @return Hashed password with salt, Base64 encoded
     */
    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);

            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            // Add salt to digest
            md.update(salt);

            // Get the hashed password
            byte[] hashedPassword = md.digest(password.getBytes());

            // Store both salt and hashed password
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);

            // Return as Base64 encoded string
            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

}