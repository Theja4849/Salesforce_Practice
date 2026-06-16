public with sharing class PatientSummaryController {

    public class SummaryWrapper {
        @AuraEnabled public Integer totalPatients;
        @AuraEnabled public Integer newPatients;
        @AuraEnabled public Integer followUpPatients;
    }

    @AuraEnabled(cacheable=true)
    public static SummaryWrapper getPatientSummary() {
        SummaryWrapper summary = new SummaryWrapper();

        summary.totalPatients =
            [SELECT COUNT() FROM Patient__c];

        summary.newPatients =
            [SELECT COUNT()
             FROM Patient__c
             WHERE Status__c = 'New'];

        summary.followUpPatients =
            [SELECT COUNT()
             FROM Patient__c
             WHERE Status__c = 'Follow-Up Required'];

        return summary;
    }
}