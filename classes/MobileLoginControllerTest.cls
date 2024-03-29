@isTest
class MobileLoginControllerTest {
    @isTest
    static void testGetCustomerRec() {
        try {
            // Create test data
            Bank__c Testbank = new Bank__c(
            Name='Test Bank');
      		  insert Testbank;
            
            Customers__c testCustomer = new Customers__c(
                Name = 'Test Customer',
        		Customer_Id__c = '1234567',
        		Bank__c = Testbank.Id,
        		Password__c = 'Password@123',
        		User_name__c = 'sagar0330',
        		PAN__c = 'EWWPD6727H',
       			Date_of_Birth__c = Date.valueOf(System.now()),
        		Mobile_Phone__c = '1234567890',
        		Zip_Code__c = 'A067',
        		Email__c = 'Sagar.Hs@cognizant.com'
            );
            insert testCustomer;
            
            // Start the test context
            Test.startTest();
            
            // Call the method being tested
            MobileLoginController.LoginResult result = MobileLoginController.getCustomerRec('1234567890', 'password@123');
            MobileLoginController.LoginResult result2 = MobileLoginController.getCustomerRec('1234598099', 'password@123');
            // Stop the test context
            Test.stopTest();
            
            // Verify the result
            System.assertEquals(true, result.success);
            System.assertEquals(testCustomer.Id, result.recordId);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw e;
        }
    }
}