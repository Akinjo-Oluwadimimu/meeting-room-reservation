<%@page import="com.roomreserve.util.SettingsService"%>
<%
// Get the settings service from application context
SettingsService settings = (SettingsService) application.getAttribute("settingsService");
boolean allowWeekends = settings.getBooleanSetting("allow_weekend_bookings", false);
int maxBookingDays = settings.getIntSetting("max_booking_days", 30);
int minBookingHours = settings.getIntSetting("min_booking_hours", 2);
int minMeetingDuration = settings.getIntSetting("min_meeting_duration", 15);
int maxMeetingDuration = settings.getIntSetting("max_meeting_duration", 240);
boolean allowBusinessHours = settings.getBooleanSetting("allow_only_business_hours", false);
%>
<script>
    const bookingConfig = {
        allowWeekends: <%= allowWeekends %>,
        maxBookingDays: <%= maxBookingDays %>,
        minBookingHours: <%= minBookingHours %>,
        minBookingDuration: <%= minMeetingDuration %>,
        maxBookingDuration: <%= maxMeetingDuration %>,
        allowBusinessHours: <%= allowBusinessHours %>,
    };
</script>