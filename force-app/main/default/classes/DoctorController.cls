public with sharing class DoctorController {
    @AuraEnabled(cacheable=true)
    public static List<Doctor__c> getAvailableDoctors() {
        return [
            SELECT Id,
                   Name,
                   Specialization__c,
                   Availability_Status__c,
                   Consultation_Fee__c
            FROM Doctor__c
            WHERE Is_Active__c = true
            ORDER BY Name
            LIMIT 10
        ];
    }
}