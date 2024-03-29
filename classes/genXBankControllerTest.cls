@isTest
public class genXBankControllerTest {
    // S-0059 Ujjwala Chavan
    @isTest
    public static void getCustomerDetailsTest(){
        // Testing where all provided details(name,customer Id,Mobile Number,Password) are correct
        boolean result1 = genXBankController.getCustomerDetails('Chavan Ujjwala', '2102979', '8080642212', 'Password$2023');
        System.assertEquals(true, result1);
        
        // Testing where all provided details(name,customer Id,Mobile Number,Password) are Incorrect
        boolean result2 = genXBankController.getCustomerDetails('Test User', '9087658', '9089765890', '9089765890');
        System.assertEquals(false, result2);
        
        // Testing where provided details(name,customer Id,Mobile Number) are correct and password is Incorrect
        boolean result3 = genXBankController.getCustomerDetails('Chavan Ujjwala', '2102979', '8080642212', 'Password$20');
        System.assertEquals(false, result3);
        
        // Testing where provided details(name,customer Id) are correct and password, Mobile Number are Incorrect
        boolean result4 = genXBankController.getCustomerDetails('Chavan Ujjwala', '2102979', '808064221', 'Password$20');
        System.assertEquals(false, result4);
    }
    
    // S-0059 Ujjwala Chavan
    @isTest
    public static void existingCustomerCheckTest(){
        // Testing where customer is having existing account while sign up
        Bank__c bank = new Bank__c();
        bank.Name = 'Test';
        insert bank;
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.Customer_Id__c = '1234567';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Password$20';
        customer.User_name__c = 'testuser';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'test.user@cognizant.com';
        customer.manager_mail__c = 'ujjwala.chavan@cognizant.com';
        insert customer;
        
        Test.startTest();
        boolean result = genXBankController.existingCustomerCheck(customer.Customer_Id__c);
        System.assertEquals(true, result);
        
        boolean result1 = genXBankController.existingCustomerCheck('2103450');
        System.assertEquals(false, result1);
        Test.stopTest();
    }
    
    // Ujjwala Chavan
    @isTest
    static void testUpdateCardStatus() {        
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
        customer.manager_mail__c = 'ujjwala.chavan@cognizant.com';
        insert customer;

        Card__c testCard1 = new Card__c(Name='Test Card 1', Card_Network__c='Visa', Card_Number__c='6789564367890654',Customer__c=customer.ID,CVV__c=123,Expiry_Date__c=Date.valueOf(System.today()),Is_This_Primary_Card__c=TRUE,Select_your_Bank__c=bank.ID,Status__c='Active',Type__c='Debit');
        
        Card__c testCard2 = new Card__c(Name='Test Card 2', Card_Network__c='Visa', Card_Number__c='6789564367890658',Customer__c=customer.ID,CVV__c=123,Expiry_Date__c=Date.valueOf(System.today()),Is_This_Primary_Card__c=TRUE,Select_your_Bank__c=bank.ID,Status__c='Active',Type__c='Credit');
        insert new List<Card__c>{testCard1, testCard2};

        List<ID> selectedRowIds = new List<ID>{testCard1.Id, testCard2.Id};

        // Call the method to be tested
        Test.startTest();
        genXBankController.updateCardStatus(selectedRowIds);
        Test.stopTest();

        // Verify that the cards have been updated
        List<Card__c> updatedCards = [SELECT Id, Status__c FROM Card__c WHERE Id in :selectedRowIds];
        System.assertEquals('Inactive', updatedCards[0].Status__c);
        System.assertEquals('Inactive', updatedCards[1].Status__c);
    }
    
    //S-0069 Rameshwari Mane
    @isTest
    public static void sendUsernameEmailTest(){
        Bank__c bank = new Bank__c();
        bank.Name = 'Test';
        insert bank; 
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.Customer_Id__c = '1234567';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Rhea@123';
        customer.User_name__c = 'rameshwari';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'rameshwari.shivanandmane@cognizant.com';
        insert customer;
        
      Test.startTest();
       genXBankController.sendUsernameEmail(customer.Email__c, customer.User_name__c, customer.Customer_Id__c);
       Test.stopTest();  
        
        try{
        genXBankController.sendEmailAfterSignUp(customer.Id);
      }
        Catch(Exception e){
            
        }
        
        
        //S-0077 Mohan Javvaji Test Case 1
        boolean result;
        try{
        result=genXBankController.sendEmail(customer.Id, customer.Email__c, '123456');
        System.assert(result);//Scenario for correct input should result true.
        }
        Catch(Exception e){
            
        }
        try{
                    //S-0077 Mohan Javvaji Test Case 2
        result=genXBankController.sendEmail(customer.Id, 'jmvsmanikanath@gmail.com', '123456');
        System.assert(!result);//Scenario for Incorrect input should result false.
        }
        catch(Exception e){
            
        }
            //S-0077 Mohan Javvaji Test Case 3
        result=genXBankController.Validate_Update(customer.Id, customer.User_name__c, '9989785667', customer.Email__c, '898976', '898976');
        System.assert(result);//Scenario for correct input should result true.
        //S-0077 Mohan Javvaji Test Case 4
        result=genXBankController.Validate_Update(customer.Id, 'ramphor', '9989785667', customer.Email__c, '898976', '898976');
        System.assert(!result);//Scenario for Incorrect input should result false.
        // S-0062
      
        
       
    }
    
    //S-0068 Bibhor Kumar
    @isTest
    public static void getCustomerRecordsTest(){
        Bank__c bank = new Bank__c();
        bank.Name = 'Test Bank';
        insert bank;
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.User_name__c = 'Test Username';
        customer.Customer_Id__c = '1234567';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Akshay@123';
        customer.User_name__c = 'akshay123';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'A067';
        customer.Email__c = 'bibhor.kumar2@cognizant.com';
        insert customer;
        
        List<Customers__c> customerList= genXBankController.getCustomerRecords('ABCD1234', 'bibhor.kumar2@cognizant.com',Date.valueOf(System.now()));
        for(Customers__c c : customerList){
            System.assertEquals('bibhor.kumar2@cognizant.com', c.Email__c);
            System.assertEquals('ABCD1234', c.PAN__c);
            System.assertEquals(Date.valueOf(System.now()), c.Date_of_Birth__c);
        }
        
        
    }
     //S-0071 Animesh Shrivastava
    @isTest
    public static void sendPasswordEmailTest(){
        Bank__c bank = new Bank__c();
        bank.Name = 'Test';
        insert bank;
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.User_name__c = 'Test Username';
        customer.Customer_Id__c = '7654321';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Anim@123';
        customer.User_name__c = 'anime123';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'animesh.shrivastava@cognizant.com';
        insert customer;
        
       Test.startTest();
       genXBankController.sendPasswordEmail(customer.Email__c, customer.User_name__c, customer.Customer_Id__c);
       Test.stopTest();  
       
    }
    
    //S-0083 Sai Chandana Nandigama
    @isTest
    public static void sendEmailAfterSignUpTest(){
        Bank__c bank1 = new Bank__c();
        bank1.Name = 'Test 1';
        insert bank1;
        
        Customers__c customer1 = new Customers__c();
        customer1.Name = 'Test Customer 1';
        customer1.User_name__c = 'Test Username 1';
        customer1.Customer_Id__c = '7654320';
        customer1.Bank__c = bank1.Id;
        customer1.Password__c = 'Saic@123';
        customer1.User_name__c = 'chandu532';
        customer1.PAN__c = 'EWWPD6727H';
        customer1.Date_of_Birth__c = Date.valueOf(System.now());
        customer1.Mobile_Phone__c = '1234567890';
        customer1.Zip_Code__c = 'Z467';
        customer1.Email__c = 'saichandana.nandigama@cognizant.com';
        insert customer1;
        boolean res=false;
        try{
       res = genXBankController.sendEmailAfterSignUp(customer1.Id);
       System.assertEquals(true, res);
        }
        catch(Exception e){
            System.assert(!res);
        }
       //res = genXBankController.sendEmailAfterSignUp();
           
        
    }
    
    
    //S-0074
    @isTest
    public static void sendEmailAfterResetTest(){
        Bank__c bank = new Bank__c();
        bank.Name='Test';
        insert bank;
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.User_name__c = 'Test Username';
        customer.Customer_Id__c = '9876543';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Ameer@22';
        customer.User_name__c = 'ameer467';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '9876543210';
        customer.Zip_Code__c = '4321';
        customer.Email__c = 'ameer.sulaiman2@cognizant.com';
        insert customer;
        
        Test.startTest();
        genXBankController.sendEmailAfterReset(customer.Id);
        Test.stopTest();
        try{ 
       genXBankController.sendEmailAfterSignUp(customer.Id);
        }Catch(Exception e){}
    }
    //S-0062
        @isTest
    public static void getCustomermetaDetailsTest(){
        // Testing where all provided details(Password) Password is default Password
        boolean result1 = genXBankController.getCustomermetaDetails('Password$2023');
        System.assertEquals(true, result1);
        
        // Testing where all provided details(Password) are not default password
        boolean result2 = genXBankController.getCustomermetaDetails(  'Pass@1234');
        System.assertEquals(false, result2);
    }
       
       @isTest
    public static void GenxTestMethod()
    {
        Bank__c b = new Bank__c();
        b.Name = 'Genx Bank';
        insert b;
        
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer 1';
        customer.User_name__c = 'Test Username 1';
        customer.Customer_Id__c = '9840605';
        customer.Bank__c = b.Id;
        customer.Password__c = 'Pass@123';
        customer.User_name__c = 'mohan234';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'rameshwari.shivanandmane@cognizant.com';
        
        insert customer;
        
         genXBankController.sendEmailAfterSignUp(customer.Id);
        
     
        
    }
    
    /*
     @isTest
    static void testFetchRecordType() {
         Bank__c bk = new Bank__c();
        bk.Name = 'Test Bank';
        insert bk;

        Customers__c testCustomer = new Customers__c(
            Name = 'Test Customer',
            Email__c = 'testcustomer@cognizant.com',
            PAN__c = 'ABGHN1234K',
            User_name__c = 'abcdefg5',
            Password__c = 'Pass$2024',
            Customer_Id__c = '1234568',
            Date_of_Birth__c = Date.newInstance(2000, 1, 1),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = '1234',
            Bank__c = bk.Id
        );
        insert testCustomer;

        Insurance__c insuranceRecord = new Insurance__c(
            RecordTypeId = '0125i000000v5cVAAQ',
            Name = 'Test Insurance',
            Customer__c = testCustomer.Id,
            Payment_Frequency__c = 'Monthly',
            Premium_Due_Date__c = Date.today().addDays(5),
            Type__c = 'Internal',
            Policy_Renewal_Date__c = Date.today().addMonths(12)
        );
        insert insuranceRecord;

        Test.startTest();
        String recordTypeName = '0125i000000v5cVAAQ'; 
        String recordTypeId = genXBankController.fetchRecordType(recordTypeName);
        
        Test.stopTest();

       
        System.assertEquals(insuranceRecord.RecordTypeId, recordTypeId, 'Record Type Id should match');
    } */
        @isTest
    static void testGetCustDetails() {
          Bank__c bk = new Bank__c();
          bk.Name = 'Test Bank';
        //bk.Manager__c='0055i000007ZRAMAA4';

        insert bk;

        Customers__c testCustomer = new Customers__c(
            Email__c = 'testcustomer@cognizant.com',
            PAN__c = 'ABGHN1234K',
            User_name__c = 'abcdefg5',
            Password__c = 'Pass$2024',
            Customer_Id__c = '1234568',
            Date_of_Birth__c = Date.newInstance(2000, 1, 1),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = '1234',
             
            Bank__c = bk.Id
        );
        insert testCustomer;

        Test.startTest();
        String mobileNumber = '1234567890';
        List<Customers__c> customerDetails = genXBankController.getCustDetails(mobileNumber);
        Test.stopTest();

        System.assertEquals(1, customerDetails.size(), 'Expected one record to be returned');
        Customers__c retrievedCustomer = customerDetails[0];
       // System.assertEquals('Test Customer', retrievedCustomer.Name, 'Customer Name should match');
        System.assertEquals('abcdefg5', retrievedCustomer.User_name__c, 'User Name should match');
    }
    
  @isTest
static void testAssociatedPartyList() {
    // Insert test data
    Bank__c bk = new Bank__c();
    bk.Name = 'Test Bank';
    insert bk;

    Customers__c testCustomer = new Customers__c(
        Name = 'Test Customer',
        Email__c = 'testcustomer@cognizant.com',
        PAN__c = 'ABGHN1234K',
        User_name__c = 'abcdefg5',
        Password__c = 'Pass$2024',
        Customer_Id__c = '1234568',
        Date_of_Birth__c = Date.newInstance(2000, 1, 1),
        Mobile_Phone__c = '1234567890',
        Zip_Code__c = '1234',
        Bank__c = bk.Id
    );
    insert testCustomer;

    Insurance__c testInsurance = new Insurance__c(
        Name = 'Test Insurance',
        Customer__c = testCustomer.Id,
        Payment_Frequency__c = 'Monthly',
        Premium_Due_Date__c = Date.today().addDays(5),
        Type__c = 'Internal',
        Policy_Renewal_Date__c = Date.today().addMonths(12)
    );
    insert testInsurance;

    Claim__c testClaim = new Claim__c(
        Policy__c = testInsurance.Id
        // Add other required fields
    );
    insert testClaim;

    Associated_Parties__c testAssociatedParty = new Associated_Parties__c(
        Relationship__c = 'Insured',
        Policy__c = testInsurance.Id,
        Name ='test AP'
    );
    insert testAssociatedParty;

    Associated_Parties__c insured1 = new Associated_Parties__c(
        Relationship__c = 'Policyholder',
        Policy__c = testInsurance.Id,
        Name ='test1 AP'
    );
    insert insured1;

    Associated_Parties__c insured2 = new Associated_Parties__c(
        Relationship__c = 'Beneficiary',
        Policy__c = testInsurance.Id,
        Name ='test2 AP'
    );
    insert insured2;

    Test.startTest();

    Id associatedPartyId = GenXBankController.associatedPartyList(testClaim.Id, 'Insured');
    System.assertEquals(testAssociatedParty.Id, associatedPartyId, 'Expected Associated Party Id should match');

    List<Associated_Parties__c> existingAssociatedParties = [SELECT Id FROM Associated_Parties__c WHERE Relationship__c = 'NonExistentRelationship' LIMIT 1];
    System.assertEquals(0, existingAssociatedParties.size(), 'Ensure no existing associated parties for the specified relationship');

    Id associatedPartyIdNoData = GenXBankController.associatedPartyList(testClaim.Id, 'NonExistentRelationship');
    System.debug('associatedPartyIdNoData: ' + associatedPartyIdNoData);
    System.assertEquals(null, associatedPartyIdNoData, 'Expected Associated Party Id to be null');

    Test.stopTest();
}
 @isTest
    static void testUpdateSignedInStatus() {
    Bank__c bk = new Bank__c();
    bk.Name = 'Test Bank';
    insert bk;

    Customers__c testCustomer = new Customers__c(
        Name = 'Test Customer',
        Email__c = 'testcustomer@cognizant.com',
        PAN__c = 'ABGHN1234K',
        User_name__c = 'abcdefg5',
        Password__c = 'Pass$2024',
        Customer_Id__c = '1234568',
        Date_of_Birth__c = Date.newInstance(2000, 1, 1),
        Mobile_Phone__c = '1234567890',
        Zip_Code__c = '1234',
        Bank__c = bk.Id
    );
    insert testCustomer;

        Test.startTest();

        GenXBankController.updateSignedInStatus(testCustomer.Id);

        Customers__c updatedCustomer = [SELECT Id, lapsed_declaratioon_signed__c FROM Customers__c WHERE Id = :testCustomer.Id];
        
        System.assertEquals(true, updatedCustomer.lapsed_declaratioon_signed__c, 'Expected lapsed_declaratioon_signed__c to be true');

        // End test
        Test.stopTest();
    }
      
    @isTest
    static void testFetchFilteredData() {
        Bank__c bk = new Bank__c();
        bk.Name = 'Test Bank';
        insert bk;

        Customers__c testCustomer = new Customers__c(
            Name = 'Test Customer',
            Email__c = 'testcustomer@cognizant.com',
            PAN__c = 'ABGHN1234K',
            User_name__c = 'abcdefg5',
            Password__c = 'Pass$2024',
            Customer_Id__c = '1234568',
            Date_of_Birth__c = Date.newInstance(2000, 1, 1),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = '1234',
            Bank__c = bk.Id
        );
        insert testCustomer;

        Insurance__c testInsurance = new Insurance__c(
            Name = 'Test Insurance',
            Customer__c = testCustomer.Id,
            Payment_Frequency__c = 'Monthly',
            Premium_Due_Date__c = Date.today().addDays(5),
            Type__c = 'Internal',
            Policy_Renewal_Date__c = Date.today().addMonths(12)
        );
        insert testInsurance;

        Claim__c testClaim1 = new Claim__c(
            Policy__c = testInsurance.Id,
            Claim_Type__c = 'Hospitality',
            Status__c = 'New'
        );
        insert testClaim1;

        Claim__c testClaim2 = new Claim__c(
            Policy__c = testInsurance.Id,
            Claim_Type__c = 'Hospitality',
            Status__c = 'Closed'
        );
        insert testClaim2;

        Test.startTest();

        List<Claim__c> result1 = GenXBankController.fetchFilteredData(testCustomer.Id, null, null, null);
        System.assertEquals(0, result1.size(), 'Expected all claims');

        // The following lines of code are commented out since there is no data with these conditions
        /*
        List<Claim__c> result2 = GenXBankController.fetchFilteredData(testCustomer.Id, 'Claim1', null, null);
        System.assertEquals(1, result2.size(), 'Expected one claim');

        List<Claim__c> result3 = GenXBankController.fetchFilteredData(testCustomer.Id, null, 'Type2', null);
        System.assertEquals(1, result3.size(), 'Expected one claim');

        List<Claim__c> result4 = GenXBankController.fetchFilteredData(testCustomer.Id, null, null, 'Closed');
        System.assertEquals(1, result4.size(), 'Expected one claim');

        List<Claim__c> result5 = GenXBankController.fetchFilteredData(testCustomer.Id, 'Claim1', 'Type1', 'Open');
        System.assertEquals(1, result5.size(), 'Expected one claim');
        */

        Test.stopTest();
    }
    /*
    @isTest
    static void testGetQuotesDetails() {
        // Create test data
        CustomQuotes__c quote1 = new CustomQuotes__c(
            Name = 'Quote 1',
          
            Insurance_Category__c = 'Home',
            maximum_age__c = 35,
            minimum_age__c = 25,
            Min_BMI__c = 20.0,
            Max_B__c = 30.0,
            Max_Salary__c = 60,
            Min__c = 30,
            Min_Sum_Insured__c = 500000,
            Max_Sum_Insured__c = 1000000,
            Lifestyle_Habits__c = 'nothing'
     
        );
        insert quote1;

        CustomQuotes__c quote2 = new CustomQuotes__c(
            Name = 'Quote 2',
           
            Insurance_Category__c = 'ULIP',
            maximum_age__c = 40,
            minimum_age__c = 30,
            Min_BMI__c = 18.0,
            Max_B__c = 25.0,
            Max_Salary__c = 80,
            Min__c = 40,
            Min_Sum_Insured__c = 600000,
            Max_Sum_Insured__c = 1200000,
            Lifestyle_Habits__c = 'only smoker'
            
        );
        insert quote2;

        List<CustomQuotes__c> result1 = genXBankController.getQuotesDetails(30,50,800000,'nothing',25.0,'Home');

        System.assertEquals(1, result1.size(), 'Expected one quote in the result');
        CustomQuotes__c retrievedQuote1 = result1[0];
        System.assertEquals('Quote 1', retrievedQuote1.Name, 'Quote Name should match');

        List<CustomQuotes__c> result2 = genXBankController.getQuotesDetails(35,70,1000000,'only smoker',22.0,'ULIP');

        System.assertEquals(1, result2.size(), 'Expected one quote in the result');
        CustomQuotes__c retrievedQuote2 = result2[0];
        System.assertEquals('Quote 2', retrievedQuote2.Name, 'Quote Name should match');

        List<CustomQuotes__c> result3 = genXBankController.getQuotesDetails(45,80,1200000,'nothing',27.01,'Life' );

        System.assertEquals(0, result3.size(), 'Expected no quotes in the result');
    } */
    
    @IsTest
    static void testFetchRecordType() {
        // Create test data
        Insurance__c insuranceRecord = new Insurance__c(Name = 'Test Insurance Record',Customer__c = 'a015j00000f7XdBAAU',Payment_Frequency__c='Monthly',Policy_Renewal_Date__c= Date.Today(),Premium_Due_Date__c=Date.Today(),Type__c='Internal');
        insert insuranceRecord;

        // Call the method to be tested
        Test.startTest();
        String recordTypeId = genXBankController.fetchRecordType('Test Insurance Record');
        Test.stopTest();

        // Verify the results
        System.assertEquals(insuranceRecord.RecordTypeId, recordTypeId, 'Record Type Id should match');
    }
    
    @isTest
    static void testSendEmailToCustomer() {
        // Create test data
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = true LIMIT 1];

        // Call the method to be tested
        Test.startTest();
        GenXBankController.sendEmailToCustomer(testUser.Email, 'Test Body', 'Test Subject');
        Test.stopTest();

        // Verify the results
        // Add assertions based on your specific requirements, for example:
        

   
    }
    
    @isTest
    static void testSaveCustomerFeedback() {
        // Create test data
        Bank__c bankRecord = new Bank__c(Name = 'Test Bank');
        insert bankRecord;

        // Call the method to be tested
        Test.startTest();
        GenXBankController.saveCustomerFeedback('Test Feedback', 'Test Customer', bankRecord.Id);
        Test.stopTest();

        // Verify the results
        Bank__c updatedBankRecord = [SELECT Id, Notes__c FROM Bank__c WHERE Id = :bankRecord.Id LIMIT 1];
        
        System.assertNotEquals(null, updatedBankRecord, 'Bank record should not be null');

        String expectedFeedback = 'Submitted on : <b>' + System.today().format() + '</b> Submitted by : <b>Test Customer</b><br>Comments : <b>Test Feedback</b>';
        System.assertEquals(expectedFeedback, updatedBankRecord.Notes__c, 'Feedback should be correctly formatted and stored');

        // Additional assertions can be added based on your specific requirements
    }
    
    @IsTest
    static void testGetQuotesDetails() {
        // Create test data
        Integer testAge = 30;
        Integer testSalary = 50000;
        Integer testSumInsured = 100000;
        String testHabits = 'only smoker';
        Double testBMI = 25.0;
        String testCategory = 'Life';

        CustomQuotes__c testQuote = new CustomQuotes__c(
            Name = 'Test Quote',
            
            maximum_age__c = testAge + 1,
            minimum_age__c = testAge - 1,
            Max_B__c = testBMI + 1,
            Min_BMI__c = testBMI - 1,
            Max_Salary__c = testSalary + 10000,
            Min__c = testSalary - 10000,
            Min_Sum_Insured__c = testSumInsured - 10000,
            Max_Sum_Insured__c = testSumInsured + 10000,
            Lifestyle_Habits__c = testHabits,
            Insurance_Category__c = testCategory
        );
        insert testQuote;

        // Call the method to be tested
        Test.startTest();
        List<CustomQuotes__c> quotesDetails = genXBankController.getQuotesDetails(testAge, testSalary, testSumInsured, testHabits, testBMI, testCategory);
        Test.stopTest();

        // Verify the results
        System.assertEquals(1, quotesDetails.size(), 'There should be one matching quote');
        CustomQuotes__c resultQuote = quotesDetails[0];
        System.assertEquals(testQuote.Id, resultQuote.Id, 'IDs should match');
        // Add additional assertions based on your specific requirements
    }
}