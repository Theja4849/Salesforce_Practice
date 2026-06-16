public with sharing class getTopRevenueAccounts {
    // @AuraEnabled is an Apex annotation that exposes Apex methods and properties to Lightning technologies
    //  such as LWC and Aura Components. Without it,client-side components cannot access Apex code.
    // Just like a REST API exposes backend functionality to external applications, @AuraEnabled exposes 
    // Apex functionality to Lightning Components. That's the core purpose.
    @AuraEnabled(cacheable=true)
    public static List<Account> getTopRevenueAccounts() {
        try {
            return  [select Id,Name,AnnualRevenue,Phone,Rating from Account ORDER BY AnnualRevenue DESC NULLS LAST  LIMIT 5 ];
        } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            
        }
 
    }
}


// 1. what is cacheable=true:
//     this tells salesforce that this is read only method no DML,No updates, no inserts, no deletes Salesforce can cache the result.
//     we use this annotation on variables too