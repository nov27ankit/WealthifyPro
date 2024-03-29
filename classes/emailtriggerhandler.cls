public class emailtriggerhandler {
    public static void passwordchangedate(list<Customers__c> clist, Map<Id,Customers__c> oldMap) {
        for(Customers__c conRecord: clist){  
       if(conRecord.Password__c != oldMap.get(conRecord.Id).Password__c || oldMap.get(conRecord.Id).Password__c =='Password$2023'){  
                conRecord.last_change_date__c =Date.Today();  
            }  
        }
    }  
}