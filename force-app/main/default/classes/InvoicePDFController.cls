public with sharing class InvoicePDFController {

    public Invoice__c invoiceRecord { get; private set; }

    public InvoicePDFController() {
        Id invoiceId = ApexPages.currentPage().getParameters().get('id');

        if (invoiceId != null) {
            invoiceRecord = [
                SELECT Id,
                       Name,
                       Invoice_Date__c,
                       Amount__c,
                       Tax__c,
                       Total_Amount__c,
                       Status__c,
                       Patient__r.Name,
                       Appointment__r.Name
                FROM Invoice__c
                WHERE Id = :invoiceId
                LIMIT 1
            ];
        }
    }
}