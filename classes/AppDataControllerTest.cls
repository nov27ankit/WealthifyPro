@isTest
public class AppDataControllerTest {
    @isTest
    public static void AppDataControllerTest(){
        //user c=new user(Email='ankit@gmail.com'); 
        //insert c;
        //system.debug(c); 
    	Bank__c bank=new Bank__c(Name='ICICU');
        insert bank;
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.Customer_Id__c = '1234567';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Password$20';
        customer.User_name__c = 'testuser';
        customer.PAN__c = 'BTVPV4305A';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'test.user@cognizant.com';
        //customer.manager_mail__c = 'ujjwala.chavan@cognizant.com';
        insert customer;
        Card__c card=new Card__c();
        //card.Account_Number__c= '6789564356';
        card.Name='animesh';
        card.Card_Network__c='Visa';
        card.Card_Number__c='6789564367890654';
        card.Customer__c=customer.ID;
        card.CVV__c=123;
        card.Expiry_Date__c=Date.valueOf(System.today());
        card.Is_This_Primary_Card__c=TRUE;
        card.Select_your_Bank__c=bank.ID;
        card.Status__c='active';
        card.Type__c='Debit';
        insert card;
        
        Insurance__c policy=new Insurance__c();
        policy.Name='Hello123';
        policy.Customer__c=customer.Id;
        policy.Annual_Premium_Amount__c=111111;
        //policy.Insurance_Category__c='ULIP';
        policy.Insurance_Category__c='Home';
        policy.Company_Provider__c='Default';
        policy.Sum_Insured__c= 2500000;
        //policy.RecordTypeId='0125i000000v5cVAAQ';
        policy.Status__c='Active';
        policy.Type__c = 'Internal';
        System.debug(Date.today());
        policy.Plan_Start_Date__c=Date.today();
        policy.Last_Premium_Date__c=Date.today();
        policy.Policy_Stage__c='Basic';
        policy.Plan_Term__c=20;
        policy.Premium_Due_Date__c=Date.today();
        policy.Policy_Renewal_Date__c=policy.Plan_Start_Date__c.addMonths(20);
        policy.Payment_Frequency__c='Monthly';
        System.debug(policy);
        insert policy;

        
        Map<Id,List<Card__c>> allcard=AppDataController.retrieveData(customer.Id,policy.ID).cardsMap;
        System.assertEquals(1,allcard.size());//Evaluates the list of return records with the actual records list
        
        boolean tf=AppDataController.fetchHealthDetailId(policy.ID);
        System.assertEquals(true,tf);
        System.debug(tf);
        
        boolean t=AppDataController.fetchDueDateStatus(Date.today().addDays(10));
        System.assertEquals(true,t);
        
        List<Insurance__c> allcar=AppDataController.fetchFilteredData(policy.ID, 'Home', 'Hello123', 'Default','111155','4500000',null,String.valueOf(Date.today().addDays(5)));
        System.assertEquals(0,allcar.size());//Evaluates the list of return records with the actual records list
        
        
    }
    public class DataWrapper {
        @AuraEnabled public Map<Id, Insurance__c> insuranceMap { get; set; }
        @AuraEnabled public Map<Id, List<Claim__c>> claimRecordMap { get; set; }
        @AuraEnabled public Map<Id, List<Associated_Parties__c>> associatedPartiesMap { get; set; }
        @AuraEnabled public Map<Id, Customers__c> customerMap { get; set; }
        @AuraEnabled public Map<Id, Bank__c> bankRecordMap { get; set; }
        @AuraEnabled public Map<Id, List<Card__c>> cardsMap { get; set; }
        @AuraEnabled public Map<Id, List<Payment__c>> paymentMap { get; set; }
    }
}