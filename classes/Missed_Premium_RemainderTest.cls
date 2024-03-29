@isTest
private class Missed_Premium_RemainderTest {
    
    @isTest
    static void testMissedPremiumBatch() {
        
        // Create test data - bank records
        List<Bank__c> testAdmins = new List<Bank__c>();
        for (Integer i = 0; i < 5; i++) {
            Bank__c bank = new Bank__c(
                Name = 'Test Bank ' + i
            );
            testAdmins.add(bank);
        }
        insert testAdmins;
        
        // Create test data - Customer records
        List<Customers__c> testCustomers = new List<Customers__c>();
        for (Integer i = 0; i < 5; i++) {
            Customers__c customer = new Customers__c(
                Name = 'Test Customer ' + i,
                Email__c = 'testcustomer' + i + '@cognizant.com',
                PAN__c = 'ABGHN1234K',
                User_name__c = 'abcdefg'+i,
                Password__c = 'Pass$2024',
                Customer_Id__c = '123456'+i,
                Date_of_Birth__c = Date.newInstance(2000, 1, 1),
                Mobile_Phone__c = '1234567890',
                Zip_Code__c = '1234',
                Bank__c = testAdmins[i].Id
            );
            testCustomers.add(customer);
        }
        insert testCustomers;
        
        // Create test data - Insurance records
        List<Insurance__c> testInsurances = new List<Insurance__c>();
        for (Integer i = 0; i < 5; i++) {
            Insurance__c insurance = new Insurance__c(
                Name = 'Test Insurance ' + i,
                Status__c = 'Active',
                Company_Provider__c = 'Test Provider' + i,
                Customer__c = testCustomers[i].Id,
                Payment_Frequency__c = 'Monthly',
                Payment_Status__c = 'Not Paid',
                Type__c = 'Internal',
                Annual_Premium_Amount__c = 12000,
                Policy_Renewal_Date__c = Date.today().addMonths(12),
                Premium_Due_Date__c = Date.today().addDays(-2) // Set due date within 2 days
            );
            testInsurances.add(insurance);
        }
        // Adding one insurance with Premium Due Date more than 3 days from today
        Insurance__c insuranceWithMoreThan3Days = new Insurance__c(
            Name = 'Test Insurance More Than 3 Days',
            Status__c = 'Active',
            Company_Provider__c = 'Test Provider More Than 3 Days',
            Customer__c = testCustomers[0].Id,
            Payment_Frequency__c = 'Monthly',
            Payment_Status__c = 'Not Paid',
            Type__c = 'Internal',
            Annual_Premium_Amount__c = 12000,
            Policy_Renewal_Date__c = Date.today().addMonths(12),
            Premium_Due_Date__c = Date.today().addDays(-5) // Set due date more than 3 days from today
        );
        testInsurances.add(insuranceWithMoreThan3Days); 

        insert testInsurances;
        
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
        
        System.schedule(jobName, cronExp, new Missed_Premium_Remainder());
        
        Missed_Premium_Remainder batchClass = new Missed_Premium_Remainder();
        Database.executeBatch(batchClass);

        System.assertEquals(0, Limits.getEmailInvocations(), 'Emails should be sent');
        Test.stopTest();
        
        // Verify that the batch job has executed
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
        System.assertEquals(1, jobs.size());
        System.debug('Job size:'+jobs.size());
        
        // Assert that the expected changes have occurred
        List<Insurance__c> updatedInsurances = [SELECT Id, Status__c FROM Insurance__c WHERE Id IN :testInsurances];
        System.assertEquals('Hibernate', updatedInsurances[0].Status__c, 'Insurance status not updated as expected');
        System.assertEquals('Lapsed', updatedInsurances[5].Status__c, 'Insurance status lapsed not updated as expected');
    }
}