trigger AccountTrigger on Account (before Insert, after Insert, before Update, after Update) {
    //String.isBlank is considered '',null,'  ' values as empty and retuns true
    //1. Trigger.new: which contains the list of records which got inserted
    //2.Trigger.old :returns the list of records that are going to insert or update  with prior values
    //3.Trigger.isBefore => which returns true if trigger is running on before event
    //4.Triigger.isInsert => which reeturns true if triggger is called when user has	 done insert operation
    //5.Trigger.isAfter => which returns true if trigger is called after the record is inserted/updated
    //6.Trigger.isUpdate => returns true if trigger is called when record is updated 
    //7.Trigger. => 
    if(Trigger.isInsert && Trigger.isBefore){
        for(Account acc: Trigger.new){
             //scenario 1: throw an error if AnnualRevenue is less than 1000
            if(acc.AnnualRevenue<1000){
                //we have one error method on object to send an error
                acc.addError('Annual revenue must be greater than 1000');
            }
             //scenario 2: mapping billing address with shipping address
            if(String.isBlank(acc.ShippingCountry) && String.isBlank(acc.ShippingCity)&& String.isBlank(acc.ShippingState) && String.isBlank(acc.ShippingStreet)){
                	acc.ShippingStreet     = acc.BillingStreet;
                acc.ShippingCity       = acc.BillingCity;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCountryCode = acc.BillingCountryCode;
                acc.ShippingStateCode   = acc.BillingStateCode;
            }
        }
    }
    //scenario3: when user created account , write a logic to create contact with same name and associate contact and account
    if(Trigger.isAfter && Trigger.isInsert){
        List<Contact> consToBeInsert= new List <Contact>();
        for (Account accRec: Trigger.new){
            Contact con = new Contact();
            con.LastName=accRec.Name;
            con.AccountId=accRec.Id;
            consToBeInsert.add(con);
        } 
        if(consToBeInsert.size()>0){
            System.debug('contacts to be inserted'+consToBeInsert);
            INSERT  consToBeInsert;
        }
    }
    //scenario:4 => when user tries to update account name throw an error that account name can't be modified after created
    if(Trigger.isUpdate && Trigger.isBefore){
        System.debug('@@@New Values'+Trigger.newMap);  //it contains new records with key value pair
          System.debug('@@@Old Values'+Trigger.oldMap); //it contains old records with key value pair    
        for(Account newAccountRec:Trigger.new){
            Account oldAccRec = Trigger.oldMap.get(newAccountRec.Id);
                if(newAccountRec.Name!=oldAccRec.Name){
                    newAccountRec.addError('Account name can not be Modified after Creating');
                }
        }       
    }
    
    //scenario: 5 => when user updating account's billing address all contacts which are linked up with it should update their email address
    if(Trigger.isUpdate && Trigger.isAfter){
        Set<Id> changedAccountIds = new Set<Id>();
        for(Account accRec:Trigger.new){
            Account oldAccRec= Trigger.oldMap.get(accRec.Id);
            if(accRec.BillingStreet!=oldAccRec.BillingStreet){
                changedAccountIds.add(accRec.Id);
            } 
        }
              //THIS LIST CONTAINS LIST ACCOUNTS WITH CONTACTS 
        List<Account> accountListWithCon =[ SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,(SELECT id,name from Contacts) from Account WHERE ID in:changedAccountIds];
            System.debug('@@@Fetched Account details'+accountListWithCon);
  
        List<Contact> contactsToBeChange = new List<Contact>();
        for(Account accList: accountListWithCon){
            List<Contact> contacts=accList.contacts;
                for(Contact con :contacts ){
                    con.MailingStreet=accList.BillingStreet;
                    con.MailingCity=accList.BillingCity;
                    con.MailingState=accList.BillingState;
                    con.MailingCountry=accList.BillingCountry;
                    contactsToBeChange.add(con);
                } 
        }
        if(contactsToBeChange.size()>0){
            UPDATE contactsToBeChange;
        }
        
        
    }

}