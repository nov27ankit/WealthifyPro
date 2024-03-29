@isTest
public class RenewalReminderBatchTest {
   
    @testSetup
    public static void dataInitialization(){
        //Create bank data
        Bank__c bk = new Bank__c();
        bk.Name = 'Test Bank';
        insert bk;
       
        //Create test data: Customers__c
        Customers__c cust = new Customers__c();
        cust.Name = 'Test1';
        cust.Bank__c = bk.Id;
        Date currentDate = System.today();
Integer daysToSubtract = 100; // Change this value to the number of days you want to subtract
Date newDate = currentDate.addDays(-daysToSubtract);
        cust.Date_of_Birth__c = newDate;
        cust.PAN__c = 'CDXCF6745H';
        cust.Zip_Code__c = '9087';
        cust.User_name__c = 'ujjwalachavan';
        cust.Mobile_Phone__c = '5678904567';
        cust.Email__c = 'ujjwala.chavan@cognizant.com';
        cust.Customer_Id__c = '4563789';
        cust.Password__c = 'Pass$2034';
        insert cust;
       
        // Create test data: Insurance__c records that meet the criteria
        List<Insurance__c> policies = new List<Insurance__c>();
        // Add test records to policies list
        for (Integer i = 0; i < 5; i++) {
            Insurance__c ins = new Insurance__c();
            ins.Name = 'Test Plan ' + i;
            ins.Is_Auto_Debit__c = true;
            ins.Customer__c = cust.Id;
            ins.Annual_Premium_Amount__c=10000000;
            ins.Type__c = 'Internal';
            ins.Payment_Frequency__c = 'Monthly';
            ins.Is_Renewal_Completed__c = false;
            ins.Payment_Status__c = 'Not Paid';
            ins.Status__c = 'Active';
            ins.Email__c = 'ujjwala.chavan@cognizant.com';
            ins.Company_Provider__c = 'Star Life'+i;
            ins.Policy_Renewal_Date__c = System.today()+1;
            if(i==0){
                ins.Premium_Due_Date__c=date.today().addDays(-15);
            }
            else if(i==1){
                ins.Premium_Due_Date__c=date.today().addDays(-7);
            }
            else if(i==2){
                ins.Premium_Due_Date__c=date.today().addDays(-3);
            }
            else{
                ins.Premium_Due_Date__c=date.today().addDays(-1);
            }
           
            Date currentDate1 = System.today();
Integer yearsToSubtract = 1;
Date oneYearBack = currentDate1.addYears(-yearsToSubtract);
            ins.Plan_Start_Date__c = oneYearBack.addDays(-4);
            ins.Plan_Term__c = 12;
           
            policies.add(ins);
        }
       
        // Insert the test records
        insert policies;
    }
   
    @isTest
    static void testRenewalReminderBatch() {
       
        Test.startTest();
        // Schedule the batch job
        String jobName = 'Renewal Reminder Job Test';
        Datetime startTime = System.now();
        String cronExp = String.valueOf(startTime.second()) + ' ' +
            String.valueOf(startTime.minute() + 1) + ' ' +  // Schedule for the next minute
            String.valueOf(startTime.hour()) + ' ' +
            String.valueOf(startTime.day()) + ' ' +
            String.valueOf(startTime.month()) + ' ' +
            '?' + ' ' +
            String.valueOf(startTime.year());
       
        System.schedule(jobName, cronExp, new RenewalReminderBatch());
       
        RenewalReminderBatch batch = new RenewalReminderBatch();
        Database.executebatch(batch, 200);

        System.assertEquals(0, Limits.getEmailInvocations(), 'Emails should be sent');
        Test.stopTest();
       
        // Verify that the batch job has executed
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
        System.assertEquals(1, jobs.size());
        System.debug('Job size:'+jobs.size());
    }
   
    @isTest
    public static void testPremiumDueRemaindersBatch(){
        Test.startTest();
        // Schedule the batch job
        String jobName = 'Premium Reminder Job Test';
        Datetime startTime = System.now();
        String cronExp = String.valueOf(startTime.second()) + ' ' +
            String.valueOf(startTime.minute() + 1) + ' ' +  // Schedule for the next minute
            String.valueOf(startTime.hour()) + ' ' +
            String.valueOf(startTime.day()) + ' ' +
            String.valueOf(startTime.month()) + ' ' +
            '?' + ' ' +
            String.valueOf(startTime.year());
       
        System.schedule(jobName, cronExp, new Premium_Due_Remainders());
       
        Premium_Due_Remainders pdr = new Premium_Due_Remainders();
        Database.executebatch(pdr, 200);

        System.assertEquals(0, Limits.getEmailInvocations(), 'Emails should be sent');
        Test.stopTest();
       
        // Verify that the batch job has executed
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
        System.assertEquals(1, jobs.size());
        System.debug('Job size:'+jobs.size());

    }
}