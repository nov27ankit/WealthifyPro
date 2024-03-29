@isTest
public class loginControllerTest {
	@isTest
    static void testGetCustomerRec() {
        try {
            // Create test data
            Bank__c Testbank = new Bank__c(
            Name='Test Bank');
      		  insert Testbank;
            
            Customers__c testCustomer = new Customers__c(
                Name = 'Test Customer',
        		Customer_Id__c = '2189998',
        		Bank__c = Testbank.Id,
        		Password__c = 'Password@123',
        		User_name__c = 'jayayadav',
        		PAN__c = 'BTVPV4305A',
       			Date_of_Birth__c = Date.valueOf(System.now()),
        		Mobile_Phone__c = '9637583997',
        		Zip_Code__c = 'A067',
        		Email__c = 'jaya.yadav@cognizant.com'
            );
            insert testCustomer;
            
            // Start the test context
            Test.startTest();
            
            // Call the method being tested
            loginController.LoginClick result = loginController.getCustomerRecords('2189998', 'password@123');
            loginController.LoginClick result2 = loginController.getCustomerRecords('1234567', 'password@193');
            // Stop the test context
            Test.stopTest();
            
            // Verify the result
            System.assertEquals(true, result.isValid);
            System.assertEquals(testCustomer.Id, result.recordId);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw e;
        }
    }
}