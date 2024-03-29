public with sharing class loginController {
    public class LoginClick {
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public Id recordId;
        @AuraEnabled public Boolean isFirstTimeuser;
    }
    @AuraEnabled(cacheable=true)
    public static LoginClick getCustomerRecords(String userNameOrCustomerId, String password){
        LoginClick result = new LoginClick();
        List<Customers__c> customers = [
            SELECT Id, Is_First_Time_User__c
            FROM Customers__c
            WHERE (User_name__c = :userNameOrCustomerId OR Customer_Id__c =:userNameOrCustomerId)
            AND Password__c = :password
            LIMIT 1
        ];
        if (!customers.isEmpty()) {
            result.isValid = true;
            result.recordId = customers[0].Id;
            result.isFirstTimeuser = true;
        } else {
            result.isValid = false;
            result.isFirstTimeuser = false;
        }
        return result;   
    }
    
    
}