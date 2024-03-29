public class RelationshipManagerHandler {
    public static void updateInsertRec(List<Customers__c> ls){
        //Set<Id> bankIds = new Set<Id>();
        for(Customers__c cus : ls){
            Bank__c bank=[select id,Name,Manager__r.Name,Manager__r.Email,Registration_Number__c,IFSC_Code__c FROM Bank__c WHERE id = : cus.Bank__c];
            if(cus.Is_Active__c==true){
                cus.Relationship_manager__c = bank.Manager__r.Name;
                cus.manager_mail__c=bank.Manager__r.Email;
            }
            else{
                cus.Relationship_manager__c ='';
                cus.manager_mail__c='';
            }
        }
        
        
    }
    /*public static void insertrec(List<Customers__c> ls){
        //Set<Id> bankIds = new Set<Id>();
        for(Customers__c cus : ls){
            Id bankIds = cus.Bank__c;
            Bank__c bank=[select id,Name,Manager__r.Name,Registration_Number__c,IFSC_Code__c FROM Bank__c WHERE id = : bankIds];
            if(cus.Is_Active__c==true){
                cus.Relationship_manager__c = bank.Manager__r.Name;
            }
            else{
                cus.Relationship_manager__c ='';
            }
            
        }
        
    }*/
}