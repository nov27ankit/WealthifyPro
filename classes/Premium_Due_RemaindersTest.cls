@isTest
public class Premium_Due_RemaindersTest {
    
    @isTest
    static void testBatch() {
        // Create test data 
        Bank__c bank=new Bank__c(Name='ICICU');
        insert bank;
        
        Customers__c customer = new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c = '1234567',
            Bank__c = bank.Id,
            Password__c = 'Password$20',
            User_name__c = 'testuser',
            PAN__c = 'BTVPV4305A',
            Date_of_Birth__c = Date.valueOf(System.now()),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = 'Z467',
            Email__c = 'test.user@cognizant.com',
            manager_mail__c = 'ujjwala.chavan@cognizant.com'
        );
        insert customer;
        List<Insurance__c> insuranceList = new List<Insurance__c>();
        
        insuranceList.add(new Insurance__c(
            Name = 'Test Insurance 15 Days',
            Customer__c = customer.Id,
            Payment_Frequency__c='Monthly',
            Company_Provider__c = 'Test Provider',
            Status__c = 'Active',
            Payment_Status__c = 'Not Paid',
            Annual_Premium_Amount__c = 111111,
            Insurance_Category__c = 'Home',
            Sum_Insured__c = 2500000,
            Type__c = 'Internal',
            Plan_Start_Date__c = Date.today(),
            Premium_Due_Date__c = Date.today().addDays(15),
            Policy_Renewal_Date__c = Date.today().addMonths(20)
        ));
        
        insuranceList.add(new Insurance__c(
            Name = 'Test Insurance 7 Days',
            Customer__c = customer.Id,
            Payment_Frequency__c='Monthly',
            Company_Provider__c = 'Test Provider',
            Status__c = 'Active',
            Payment_Status__c = 'Not Paid',
            Annual_Premium_Amount__c = 111111,
            Insurance_Category__c = 'Home',
            Sum_Insured__c = 2500000,
            Type__c = 'Internal',
            Plan_Start_Date__c = Date.today(),
            Premium_Due_Date__c = Date.today().addDays(7),
            Policy_Renewal_Date__c = Date.today().addMonths(20)
        ));
        
        insuranceList.add(new Insurance__c(
            Name = 'Test Insurance 3 Days',
            Customer__c = customer.Id,
            Payment_Frequency__c='Monthly',
            Company_Provider__c = 'Test Provider',
            Status__c = 'Active',
            Payment_Status__c = 'Not Paid',
            Annual_Premium_Amount__c = 111111,
            Insurance_Category__c = 'Home',
            Sum_Insured__c = 2500000,
            Type__c = 'Internal',
            Plan_Start_Date__c = Date.today(),
            Premium_Due_Date__c = Date.today().addDays(3),
            Policy_Renewal_Date__c = Date.today().addMonths(20)
        ));
        
        insuranceList.add(new Insurance__c(
            Name = 'Test Insurance 1 Day',
            Customer__c = customer.Id,
            Payment_Frequency__c='Monthly',
            Company_Provider__c = 'Test Provider',
            Status__c = 'Active',
            Payment_Status__c = 'Not Paid',
            Annual_Premium_Amount__c = 111111,
            Insurance_Category__c = 'Home',
            Sum_Insured__c = 2500000,
            Type__c = 'Internal',
            Plan_Start_Date__c = Date.today(),
            Premium_Due_Date__c = Date.today().addDays(1),
            Policy_Renewal_Date__c = Date.today().addMonths(20)
        ));
        
        insert insuranceList;
        
        
        
        // Start the batch job
        Test.startTest();
        Premium_Due_Remainders batchClass = new Premium_Due_Remainders();
        Database.executeBatch(batchClass);
        
        // Query for the updated Insurance__c records
        List<Insurance__c> updatedInsurances = [
            SELECT Id, Payment_Status__c
            FROM Insurance__c
        ];
        
        // Verify that the Payment_Status__c field is updated for the 15 days remainder
        for (Insurance__c updatedIns : updatedInsurances) {
            System.assertEquals('Not Paid', updatedIns.Payment_Status__c);
        }
        
        Test.stopTest();
    }
    @isTest
    static void testScheduler() {
        // Start the scheduler
        Test.startTest();
        String jobId = System.schedule('Premium_Due_Remainders_Schedule', '0 0 0 * * ?', new Premium_Due_Remainders());
        Test.stopTest();
        
        // Query the CronTrigger object to ensure the job was scheduled
        CronTrigger cronTrigger = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        System.assertNotEquals(null, cronTrigger, 'Scheduler job not found');
    }
}