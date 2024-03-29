@isTest
private class DataCountControllerTest {
    
    @isTest
    static void testRetrieveDataCount() {
        // Test data setup
        Bank__c bank = new Bank__c(Name = 'ICICI');
        insert bank;
        
        Customers__c customer = new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c = '1234567',
            Bank__c = bank.Id,
            Password__c = 'Password$20',
            User_name__c = 'testuser',
            PAN__c = 'BTVPV4305A',
            Date_of_Birth__c = Date.today(),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = 'Z467',
            Email__c = 'test.user@cognizant.com',
            manager_mail__c = 'anusuryam.s@cognizant.com'
        );
        insert customer;
        
        List<Insurance__c> testInsurances = new List<Insurance__c>{
            new Insurance__c(
                Customer__c = customer.Id,
                Payment_Frequency__c = 'Monthly',
                Annual_Premium_Amount__c = 111111,
                Insurance_Category__c = 'Home',
                Company_Provider__c = 'Default',
                Sum_Insured__c = 2500000,
                Status__c = 'Active',
                Type__c = 'Internal',
                Plan_Start_Date__c = Date.today(),
                Premium_Due_Date__c = Date.today(),
                Policy_Renewal_Date__c = Date.today().addMonths(20)
            ),
                new Insurance__c(
                    Customer__c = customer.Id,
                    Payment_Frequency__c = 'Monthly',
                    Annual_Premium_Amount__c = 111111,
                    Insurance_Category__c = 'Health',
                    Company_Provider__c = 'Default',
                    Sum_Insured__c = 2500000,
                    Status__c = 'Active',
                    Type__c = 'Internal',
                    Plan_Start_Date__c = Date.today(),
                    Premium_Due_Date__c = Date.today(),
                    Policy_Renewal_Date__c = Date.today().addMonths(20)
                ),
                new Insurance__c(
                    Customer__c = customer.Id,
                    Payment_Frequency__c = 'Monthly',
                    Annual_Premium_Amount__c = 111111,
                    Insurance_Category__c = 'Vehicular',
                    Company_Provider__c = 'Default',
                    Sum_Insured__c = 2500000,
                    Status__c = 'Active',
                    Type__c = 'Internal',
                    Plan_Start_Date__c = Date.today(),
                    Premium_Due_Date__c = Date.today(),
                    Policy_Renewal_Date__c = Date.today().addMonths(20)
                ),
                new Insurance__c(
                    Customer__c = customer.Id,
                    Payment_Frequency__c = 'Monthly',
                    Annual_Premium_Amount__c = 111111,
                    Insurance_Category__c = 'Life',
                    Company_Provider__c = 'Default',
                    Sum_Insured__c = 2500000,
                    Status__c = 'Active',
                    Type__c = 'Internal',
                    Plan_Start_Date__c = Date.today(),
                    Premium_Due_Date__c = Date.today(),
                    Policy_Renewal_Date__c = Date.today().addMonths(20)
                ),
                new Insurance__c(
                    Customer__c = customer.Id,
                    Payment_Frequency__c = 'Monthly',
                    Annual_Premium_Amount__c = 111111,
                    Insurance_Category__c = 'Term',
                    Company_Provider__c = 'Default',
                    Sum_Insured__c = 2500000,
                    Status__c = 'Active',
                    Type__c = 'Internal',
                    Plan_Start_Date__c = Date.today(),
                    Premium_Due_Date__c = Date.today(),
                    Policy_Renewal_Date__c = Date.today().addMonths(20)
                ),
                new Insurance__c(
                    Customer__c = customer.Id,
                    Payment_Frequency__c = 'Monthly',
                    Annual_Premium_Amount__c = 111111,
                    Insurance_Category__c = 'ULIP',
                    Company_Provider__c = 'Default',
                    Sum_Insured__c = 2500000,
                    Status__c = 'Active',
                    Type__c = 'Internal',
                    Plan_Start_Date__c = Date.today(),
                    Premium_Due_Date__c = Date.today(),
                    Policy_Renewal_Date__c = Date.today().addMonths(20)
                )
                
                };
                    insert testInsurances;
        
        Payment__c testPayment = new Payment__c(
            Payment_Status__c = 'Completed',
            Policy__c = testInsurances[0].Id,
            Payment_By__c = customer.Id
        );
        insert testPayment;
        
        List<Claim__c> testClaims = new List<Claim__c>{
            new Claim__c(
                Policy__c = testInsurances[0].Id,
                Status__c = 'Approved-Pending Payment'
            ),
                new Claim__c(
                    Policy__c = testInsurances[0].Id,
                    Status__c = 'New'
                )
                
                };
                    insert testClaims;
        
        // Call the method want to test
        Test.startTest();
        DataCountController.DataCountWrapper result = DataCountController.retrieveDataCount(customer.Id);
        DataCountController.DataCountWrapper nullResult = DataCountController.retrieveDataCount(null);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, result.customerCount, 'Customer count is incorrect');
        System.assertEquals(testInsurances.size(), result.policyCount, 'Policy count is incorrect');
        System.assertEquals(1, result.totalPaymentCount, 'Total payment count is incorrect');
        System.assertEquals(1, result.successfulPaymentCount, 'Successful payment count is incorrect');
        System.assertEquals(testClaims.size(), result.totalClaimCount, 'Total claim count is incorrect');
        System.assertEquals(1, result.approvedClaimCount, 'Approved claim count is incorrect');
        System.assertEquals(15000000, result.totalSumInsured, 'Total sum insured is incorrect');
        System.assertEquals(1, result.healthCount, 'Health count is incorrect');
        System.assertEquals(1, result.homeCount, 'Home count is incorrect');
        System.assertEquals(1, result.vehicleCount);
        System.assertEquals(1, result.termCount);
        System.assertEquals(1, result.lifeCount);
        System.assertEquals(1, result.ulipCount);
        
        
    }
}