package com.roomreserve.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.sql.Timestamp;
import java.util.Calendar;

public class TokenGenerator {
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder();

    public static String generateToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }

    public static Timestamp getExpirationTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, 1); // 24 hours expiration
        return new Timestamp(calendar.getTimeInMillis());
    }
}