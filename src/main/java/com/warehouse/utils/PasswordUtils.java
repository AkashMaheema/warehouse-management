package com.warehouse.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    // Hash the password using BCrypt
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    // Verify the password against the stored hash
    public static boolean verifyPassword(String password, String storedHash) {
        return BCrypt.checkpw(password, storedHash);
    }

}

