public class dataCountController{
    @AuraEnabled
    public static DataCountWrapper retrieveDataCount(string customerId){
        Map<Id, Insurance__c> mapIdVsInsurance = new Map<Id, Insurance__c>();
        Map<Id, List<Payment__c>> mapIdVsPaymentRecord = new Map<Id, List<Payment__c>>();
        Map<Id, List<Payment__c>> mapIdVscompletePaymentRecord = new Map<Id, List<Payment__c>>();
        Map<Id, List<Claim__c>> mapIdVsClaimRecord = new Map<Id, List<Claim__c>>();
        Map<Id, List<Claim__c>> mapIdVsPaidClaimRecord = new Map<Id, List<Claim__c>>();
        decimal sumAmount=0.00;
        Integer healthPolicyCount=0,homePolicyCount=0,vehiclePolicyCount=0,termPolicyCount=0,lifePolicyCount=0,ulipPolicyCount=0;
        dataCountController.DataCountWrapper wrapper = new dataCountController.DataCountWrapper();
        Integer customerCount=[select count() from Customers__c];
        List<Insurance__c> insuranceList=[select id,status__c,Sum_Insured__c,Type__c,customer__c,Insurance_Category__c,
                                          (select id, status__c from Claims__r),
                                          (SELECT Id,Payment_Status__c From Payments__r)
                                          from Insurance__c WHERE Type__c = 'Internal'];
        System.debug('customerCount'+customerCount);
        System.debug('insuranceList'+insuranceList);
        if(customerId!=null){
            customerCount=1;
            for (Insurance__c insurance : insuranceList) {
                
                if(insurance.Customer__c==customerId){
                    if(insurance.status__c=='Active'){
                        mapIdVsInsurance.put(insurance.id, insurance);
                        if(insurance.Sum_Insured__c!=null){
                            sumAmount=sumAmount+insurance.Sum_Insured__c;
                        }
                        if(insurance.Insurance_Category__c=='Health'){
                            healthPolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Vehicular'){
                            vehiclePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Life'){
                            lifePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Home'){
                            homePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Term'){
                            termPolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='ULIP'){
                            ulipPolicyCount+=1;
                        }else{
                            System.debug('invalid');
                        }
                        
                    }
                    for(Payment__c p :insurance.Payments__r){
                        mapIdVsPaymentRecord.put(p.id,insurance.Payments__r);
                        if(p.Payment_Status__c=='Completed'){
                            mapIdVscompletePaymentRecord.put(p.id,insurance.Payments__r);
                        }
                    }
                    
                    for(Claim__c cl :insurance.Claims__r){
                        mapIdVsClaimRecord.put(cl.id,insurance.Claims__r);
                        if(cl.Status__c=='Approved-Pending Payment'){
                            mapIdVsPaidClaimRecord.put(cl.id,insurance.Claims__r);
                        }
                    }
                }
            }
        }
        else{
            if(insuranceList != null && insuranceList.size()>0){
                for (Insurance__c insurance : insuranceList) {
                    
                    if(insurance.status__c=='Active'){
                        mapIdVsInsurance.put(insurance.id, insurance);
                        if(insurance.Sum_Insured__c!=null){
                            sumAmount=sumAmount+insurance.Sum_Insured__c;
                        }
                        if(insurance.Insurance_Category__c=='Health'){
                            healthPolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Vehicular'){
                            vehiclePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Life'){
                            lifePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Home'){
                            homePolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='Term'){
                            termPolicyCount+=1;
                        }else if(insurance.Insurance_Category__c=='ULIP'){
                            ulipPolicyCount+=1;
                        }else{
                            System.debug('invalid');
                        }
                        
                    }
                    
                    for(Payment__c p :insurance.Payments__r){
                        mapIdVsPaymentRecord.put(p.id,insurance.Payments__r);
                        if(p.Payment_Status__c=='Completed'){
                            mapIdVscompletePaymentRecord.put(p.id,insurance.Payments__r);
                        }
                    }
                    
                    for(Claim__c cl :insurance.Claims__r){
                        mapIdVsClaimRecord.put(cl.id,insurance.Claims__r);
                        if(cl.Status__c=='Approved-Pending Payment'){
                            mapIdVsPaidClaimRecord.put(cl.id,insurance.Claims__r);
                        }
                    }
                }
                
            }
            
        }
        System.debug('mapIdVsInsurance'+mapIdVsInsurance);
        System.debug('mapIdVsClaimRecord'+mapIdVsClaimRecord);
        System.debug('mapIdVsPaidClaimRecord'+mapIdVsPaidClaimRecord);
        System.debug('mapIdVsPaymentRecord'+mapIdVsPaymentRecord);
        System.debug('mapIdVscompletePaymentRecord'+mapIdVscompletePaymentRecord);
        System.debug('mapIdVsInsurancesize'+mapIdVsInsurance.size());
        System.debug('mapIdVsClaimRecordsize'+mapIdVsClaimRecord.size());
        System.debug('mapIdVsPaidClaimRecordsize'+mapIdVsPaidClaimRecord.size());
        System.debug('mapIdVsPaymentRecordsize'+mapIdVsPaymentRecord.size());
        System.debug('mapIdVscompletePaymentRecordsize'+mapIdVscompletePaymentRecord.size());
        System.debug('sumAmount'+sumAmount);
        System.debug('healthPolicyCount'+healthPolicyCount);
        System.debug('homePolicyCount'+homePolicyCount);
        System.debug('vehiclePolicyCount'+vehiclePolicyCount);
        System.debug('termPolicyCount'+termPolicyCount);
        System.debug('lifePolicyCount'+lifePolicyCount);
        System.debug('ulipPolicyCount'+ulipPolicyCount);
        wrapper.customerCount=customerCount;
        wrapper.policyCount=mapIdVsInsurance.size();
        wrapper.totalPaymentCount=mapIdVsPaymentRecord.size();
        wrapper.successfulPaymentCount=mapIdVscompletePaymentRecord.size();
        wrapper.totalClaimCount=mapIdVsClaimRecord.size();
        wrapper.approvedClaimCount=mapIdVsPaidClaimRecord.size();
        wrapper.totalSumInsured=sumAmount;
        wrapper.healthCount=healthPolicyCount;
        wrapper.homeCount=homePolicyCount;
        wrapper.vehicleCount=vehiclePolicyCount;
        wrapper.termCount=termPolicyCount;
        wrapper.lifeCount=lifePolicyCount;
        wrapper.ulipCount=ulipPolicyCount;
        System.debug('wrapper'+wrapper);
        return wrapper;
    }
    public class DataCountWrapper{
        @AuraEnabled
        public Integer customerCount { get; set; }
        @AuraEnabled
        public Integer policyCount { get; set; }
        @AuraEnabled
        public Integer totalPaymentCount { get; set; }
        @AuraEnabled
        public Integer successfulPaymentCount { get; set; }
        @AuraEnabled
        public Integer totalClaimCount { get; set; }
        @AuraEnabled
        public Integer approvedClaimCount { get; set; }
        @AuraEnabled
        public decimal totalSumInsured { get; set; }
        @AuraEnabled
        public Integer healthCount { get; set; }
        @AuraEnabled
        public Integer homeCount { get; set; }
        @AuraEnabled
        public Integer vehicleCount { get; set; }
        @AuraEnabled
        public Integer termCount { get; set; }
        @AuraEnabled
        public Integer lifeCount { get; set; }
        @AuraEnabled
        public Integer ulipCount { get; set; }
        
    }
}