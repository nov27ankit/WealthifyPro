global class ClaimProcessBatchClass  implements Database.Batchable<sObject>{    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('inside start');        
        return Database.getQueryLocator([SELECT Id, Name, Status__c,Claim_Type__c,RecordType.DeveloperName FROM Claim__c WHERE Status__c ='Approved-Pending Payment']);        
    }      
    global void execute(Database.BatchableContext BC, List<Claim__c> scope) {
        List<Claim__c> claimsToUpdate = new List<Claim__c>();     
        for (Claim__c claimRecords : scope) {            
            claimRecords.Status__c = 'Payment Processed';
            claimRecords.OwnerId='0055j00000BS0W2AAL';
            claimsToUpdate.add(claimRecords);
        }     
        update claimsToUpdate;        
    }    
    global void finish(Database.BatchableContext BC) {
        system.debug('batch finished');        
    }
   // global void execute(SchedulableContext SC) {
       // ClaimProcessBatchClass pdr= new ClaimProcessBatchClass();
       // Database.executeBatch(pdr, 1000);
   // }
}