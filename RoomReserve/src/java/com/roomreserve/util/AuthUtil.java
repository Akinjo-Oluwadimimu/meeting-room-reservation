package com.roomreserve.util;

import java.security.SecureRandom;
import org.mindrot.jbcrypt.BCrypt;

public class AuthUtil {
    private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
    private static final String NUMBER = "0123456789";
    private static final String SPECIAL_CHARS = "!@#$%^&*()_+-=[]{}|;:,.<>?";
    
    private static final String PASSWORD_ALLOW_BASE = CHAR_LOWER + CHAR_UPPER + NUMBER + SPECIAL_CHARS;
    private static final SecureRandom random = new SecureRandom();

    // Generate a secure temporary password
    public static String generateTempPassword() {
        int length = 12; // 12 characters long
        StringBuilder sb = new StringBuilder(length);
        
        // Ensure at least one character from each group
        sb.append(CHAR_LOWER.charAt(random.nextInt(CHAR_LOWER.length())));
        sb.append(CHAR_UPPER.charAt(random.nextInt(CHAR_UPPER.length())));
        sb.append(NUMBER.charAt(random.nextInt(NUMBER.length())));
        sb.append(SPECIAL_CHARS.charAt(random.nextInt(SPECIAL_CHARS.length())));
        
        // Fill remaining with random characters from all groups
        for (int i = 4; i < length; i++) {
            sb.append(PASSWORD_ALLOW_BASE.charAt(random.nextInt(PASSWORD_ALLOW_BASE.length())));
        }
        
        // Shuffle the characters to mix the required characters
        return shuffleString(sb.toString());
    }

    // Helper method to shuffle string characters
    private static String shuffleString(String input) {
        char[] characters = input.toCharArray();
        for (int i = 0; i < characters.length; i++) {
            int randomIndex = random.nextInt(characters.length);
            char temp = characters[i];
            characters[i] = characters[randomIndex];
            characters[randomIndex] = temp;
        }
        return new String(characters);
    }
    
    // Generate a secure password hash
    public static String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }
    
    // Verify password against stored hash
    public static boolean verifyPassword(String plainTextPassword, String storedHash) {
        try {
            return BCrypt.checkpw(plainTextPassword, storedHash);
        } catch (Exception e) {
            return false;
        }
    }
}
