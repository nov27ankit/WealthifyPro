public with sharing class MobileLoginController {
public class LoginResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Id recordId;
    }
    @AuraEnabled(cacheable=true)
  public static LoginResult getCustomerRec(String mobileNumber, String password)  {
           LoginResult result = new LoginResult();
            List<Customers__c> customers = [
                SELECT Id
                FROM Customers__c
                WHERE Mobile_Phone__c = :mobileNumber
                AND Password__c = :password
                LIMIT 1
            ];
            if (!customers.isEmpty()) {
                result.success = true;
                result.recordId = customers[0].Id;
            } else {
                result.success = false;
            }
            
            return result;        
  }
    
}