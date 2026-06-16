public class AppointmentTriggerHandler {

    public static void preventDoubleBooking(
        List<Appointment__c> newAppointments,
        Map<Id, Appointment__c> oldMap
    ) {
        // Collect doctors, dates, and times from records being processed
        Set<Id> doctorIds = new Set<Id>();
        Set<Date> appointmentDates = new Set<Date>();
        Set<Time> appointmentTimes = new Set<Time>();

        for (Appointment__c appt : newAppointments) {
            // Skip incomplete records
            if (appt.Doctor__c == null ||
                appt.Appointment_Date__c == null ||
                appt.Appointment_Time__c == null) {
                continue;
            }

            // Skip if the scheduling fields did not change during update
            if (oldMap != null && oldMap.containsKey(appt.Id)) {
                Appointment__c oldAppt = oldMap.get(appt.Id);

                if (oldAppt.Doctor__c == appt.Doctor__c &&
                    oldAppt.Appointment_Date__c == appt.Appointment_Date__c &&
                    oldAppt.Appointment_Time__c == appt.Appointment_Time__c) {
                    continue;
                }
            }

            doctorIds.add(appt.Doctor__c);
            appointmentDates.add(appt.Appointment_Date__c);
            appointmentTimes.add(appt.Appointment_Time__c);
        }

        // Nothing to validate
        if (doctorIds.isEmpty()) {
            return;
        }

        // Query existing active appointments
        List<Appointment__c> existingAppointments = [
            SELECT Id,
                   Doctor__c,
                   Appointment_Date__c,
                   Appointment_Time__c,
                   Status__c
            FROM Appointment__c
            WHERE Doctor__c IN :doctorIds
              AND Appointment_Date__c IN :appointmentDates
              AND Appointment_Time__c IN :appointmentTimes
              AND Status__c NOT IN ('Cancelled', 'No Show')
        ];

        // Build a lookup map using Doctor + Date + Time as the key
        Map<String, Appointment__c> existingMap = new Map<String, Appointment__c>();

        for (Appointment__c existing : existingAppointments) {
            String key = buildKey(
                existing.Doctor__c,
                existing.Appointment_Date__c,
                existing.Appointment_Time__c
            );

            existingMap.put(key, existing);
        }

       // Validate incoming records
        for (Appointment__c appt : newAppointments) {
            if (appt.Doctor__c == null ||
                appt.Appointment_Date__c == null ||
                appt.Appointment_Time__c == null) {
                continue;
            }

            String key = buildKey(
                appt.Doctor__c,
                appt.Appointment_Date__c,
                appt.Appointment_Time__c
            );

            if (existingMap.containsKey(key)) {
                Appointment__c existing = existingMap.get(key);

                // Ignore the same record during update
                if (appt.Id != existing.Id) {
                    appt.Appointment_Time__c.addError(
                        'This doctor already has an appointment at the selected date and time.'
                    );
                }
            }
        }
    }

    private static String buildKey(Id doctorId, Date apptDate, Time apptTime) {
        return String.valueOf(doctorId) + '|' + String.valueOf(apptDate) + '|' + String.valueOf(apptTime);
    }
}