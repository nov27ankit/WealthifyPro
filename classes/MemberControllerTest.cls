@isTest
public class MemberControllerTest {
   @isTest static void testCreateNewMembers() {
        // Prepare test data 
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
        insert customer;
        
        Insurance__c policy = new Insurance__c();
policy.Name = 'testname';
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 10000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c = 5000.00;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;

        MemberController.AddMemberWrapper wrapper = new MemberController.AddMemberWrapper();
        wrapper.name = 'Test Name';
        wrapper.relation = 'Insured';
        wrapper.policy = policy.Id; 
        wrapper.gender = 'Male';
        wrapper.dob = '1990-01-01';
        wrapper.education = 'Diploma';
        wrapper.maritalStatus = 'Unmarried';
        wrapper.typeOfId = 'Voter ID Card';
        wrapper.idNumber = 'Test Id Number';
        wrapper.occupation = 'Salaried';
        wrapper.employment = 'no service';
        wrapper.salary = '5-10';
        wrapper.height = 180;
        wrapper.weight = 70.0;
        wrapper.bloodGroup = 'B+';
        wrapper.bmi = 21.6;
        wrapper.lifestyleHabits = 'Only Smoker';
        wrapper.email = 'test@cognizant.com';
        wrapper.mobile = '1234567890';
        wrapper.address = 'Test Address';
        wrapper.city = 'Mysore';
        wrapper.state = 'Karnataka';
        wrapper.country = 'India';
        wrapper.zip = '0330';
        wrapper.salaryVal = 10.0;

        List<MemberController.AddMemberWrapper> wrappers = new List<MemberController.AddMemberWrapper>();
        wrappers.add(wrapper);

        String frequency = 'Monthly';
        Boolean isAutoDebit = true;
        String debitSource = 'Credit Card';

        // Call the method to test
        Test.startTest();
        String result = MemberController.createNewMembers(wrappers, policy.Id, frequency, isAutoDebit, debitSource);
		 Test.stopTest();

        // Perform assertions
        System.assertEquals('Member added and payment details updated from apex', result);
       policy = [SELECT Payment_Frequency__c, Debit_Source__c, Is_Auto_Debit__c FROM Insurance__c WHERE Id = :policy.Id];
       
       System.assertEquals('Monthly', policy.Payment_Frequency__c);
        System.assertEquals('Credit Card', policy.Debit_Source__c);
        System.assertEquals(true, policy.Is_Auto_Debit__c);
       
       List<Associated_Parties__c> testAssociatedParties = [SELECT Name, Relationship__c, Policy__c, Gender__c, DOB__c, Education__c, Marital_Status__c, Type_Of_ID_Card__c, ID_Card_Number__c, Occupation__c, Nature_of_employment__c, Salary__c, salaries__c, Height_In_Cm__c, Weight_In_Kg__c, Blood_Group__c, Lifestyle_Habits__c, Email__c, Mobile__c, Address__c, City__c, State__c, Country__c, Zip_Code__c FROM Associated_Parties__c WHERE Policy__c = :policy.Id];
       System.assertEquals(1, testAssociatedParties.size());
        System.assertEquals('Test Name', testAssociatedParties[0].Name);
        System.assertEquals('Insured', testAssociatedParties[0].Relationship__c);
        System.assertEquals(policy.Id, testAssociatedParties[0].Policy__c);
        System.assertEquals('Male', testAssociatedParties[0].Gender__c);
        System.assertEquals(Date.valueOf('1990-01-01'), testAssociatedParties[0].DOB__c);
    }

    @isTest

    static void testHealthAddOns() {
        // Create a new Insurance__c record for testing
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
        insert customer;
        
        Insurance__c policy = new Insurance__c();
policy.Name = 'testname';
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 10000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c = 5000.00;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;

        // Call the method to be tested
        Test.startTest();
        Membercontroller.healthAddOns(policy.Id, true, true, true);
        Test.stopTest();

        // Retrieve the updated record from the database
        policy = [SELECT Maternity_Coverage__c, Medical_Checkups__c, Co_Payment__c FROM Insurance__c WHERE Id = :policy.Id];

        // Assert that the fields were updated correctly
        System.assertEquals(true, policy.Maternity_Coverage__c);
        System.assertEquals(true, policy.Medical_Checkups__c);
        System.assertEquals(true, policy.Co_Payment__c);
    }


   @isTest

    static void testVehicleAddOns() {
        // Create a new Insurance__c record for testing
      
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
        insert customer;
        
        Insurance__c policy = new Insurance__c();
policy.Name = 'testname';
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 10000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c = 5000.00;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;

        // Call the method to be tested
        Test.startTest();
        MemberController.vehicleAddOns(policy.Id, true, true, true, true);
        Test.stopTest();

        // Retrieve the updated record from the database
        policy = [SELECT Anti_Theft_Protection__c, Zero_Depriciation_Coverage__c, Natural_Disaster_Coverage__c, Personal_Accident_Cover__c FROM Insurance__c WHERE Id = :policy.Id];

        // Assert that the fields were updated correctly
        System.assertEquals(true, policy.Anti_Theft_Protection__c);
        System.assertEquals(true, policy.Zero_Depriciation_Coverage__c);
        System.assertEquals(true, policy.Natural_Disaster_Coverage__c);
        System.assertEquals(true, policy.Personal_Accident_Cover__c);
        
    }
    @isTest
  static void testHomeAddOns() {
        // Create a new Insurance__c record for testing
      
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
        insert customer;
        
        Insurance__c policy = new Insurance__c();
policy.Name = 'testname';
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 10000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c = 5000.00;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;

        // Call the method to be tested
        Test.startTest();
        MemberController.homeAddOns(policy.Id, true, true, true, true);
        Test.stopTest();

        // Retrieve the updated record from the database
        policy = [SELECT Anti_Theft_Protection__c, Co_Payment__c, Natural_Disaster_Coverage__c, Portable_Equipment_Cover__c FROM Insurance__c WHERE Id = :policy.Id];

        // Assert that the fields were updated correctly
        System.assertEquals(true, policy.Anti_Theft_Protection__c);
        System.assertEquals(true, policy.Co_Payment__c);
        System.assertEquals(true, policy.Natural_Disaster_Coverage__c);
        System.assertEquals(true, policy.Portable_Equipment_Cover__c);
    }

    @isTest

    static void testLifeAddOns() {
        // Create a new Insurance__c record for testing
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
        insert customer;
        
        Insurance__c policy = new Insurance__c();
policy.Name = 'testname';
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 10000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c = 5000.00;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;
        // Call the method to be tested
        Test.startTest();
        MemberController.lifeAddOns(policy.Id, true, true);
        Test.stopTest();

        // Retrieve the updated record from the database
        policy = [SELECT Maternity_Coverage__c, Medical_Checkups__c FROM Insurance__c WHERE Id = :policy.Id];

        // Assert that the fields were updated correctly
        System.assertEquals(true, policy.Maternity_Coverage__c);
        System.assertEquals(true, policy.Medical_Checkups__c);
    }
    @isTest

    static void testPayment() {
        // Create new Customer__c, Card__c, and Insurance__c records for testing
           Bank__c bank=new Bank__c(Name='ICICU');
        insert bank;
        System.debug(bank);
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
    
        insert customer;
        System.debug(customer);
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
        System.debug(card);
        Insurance__c policy = new Insurance__c();
policy.Name = 'Test Policy Name'+''+String.valueOf(Datetime.now().formatGMT('yyyyMMddHHmmss'));
policy.Customer__c = customer.id; // Make sure this is not null
policy.Annual_Premium_Amount__c = 1000;
policy.Insurance_Category__c = 'Health';
policy.Company_Provider__c = 'Default';
policy.Sum_Insured__c =  10000;
policy.Status__c = 'Active';
policy.Type__c = 'Internal'; // Make sure this is not null
policy.Plan_Start_Date__c = Date.today();
policy.Last_Premium_Date__c = Date.today();
policy.Policy_Stage__c = 'Basic';
policy.Plan_Term__c = 5;
policy.Premium_Due_Date__c = Date.today(); // Make sure this is not null
policy.Policy_Renewal_Date__c = policy.Plan_Start_Date__c.addMonths(5); // Make sure this is not null
policy.Payment_Frequency__c ='Monthly'; // Make sure this is not null
insert policy;
        System.debug(policy);

       
        // Prepare a list of AddMemberWrapper objects
     MemberController.AddMemberWrapper wrapper = new MemberController.AddMemberWrapper();
        wrapper.name = 'Test Name';
        wrapper.relation = 'Insured';
        wrapper.policy = policy.Id; // replace with actual Id
        wrapper.gender = 'Male';
        wrapper.dob = '1990-01-01';
        wrapper.education = 'Diploma';
        wrapper.maritalStatus = 'Unmarried';
        wrapper.typeOfId = 'Voter ID Card';
        wrapper.idNumber = 'Test Id Number';
        wrapper.occupation = 'Salaried';
        wrapper.employment = 'no service';
        wrapper.salary = '5-10';
        wrapper.height = 180;
        wrapper.weight = 70.0;
        wrapper.bloodGroup = 'B+';
        wrapper.bmi = 21.6;
        wrapper.lifestyleHabits = 'Only Smoker';
        wrapper.email = 'test@cognizant.com';
        wrapper.mobile = '1234567890';
        wrapper.address = 'Test Address';
        wrapper.city = 'Mysore';
        wrapper.state = 'Karnataka';
        wrapper.country = 'India';
        wrapper.zip = '0330';
        wrapper.salaryVal = 10.0;

        List<MemberController.AddMemberWrapper> wrappers = new List<MemberController.AddMemberWrapper>();
        wrappers.add(wrapper);
        System.debug(wrappers);

        // Call the method to be tested
        Test.startTest();
         MemberController.payment(customer.Id, 1000, card.Id, policy.Name, 10000, 'Health', 12, 'Monthly',  wrappers);
        Test.stopTest();

        // Retrieve the updated Insurance__c record from the database
        policy = [SELECT Name, Customer__c, Annual_Premium_Amount__c, Insurance_Category__c, Company_Provider__c, Sum_Insured__c, RecordTypeId, Status__c, Type__c, Plan_Start_Date__c, Last_Premium_Date__c, Policy_Stage__c, Plan_Term__c, Premium_Due_Date__c, Policy_Renewal_Date__c, Payment_Frequency__c, Payment_Status__c FROM Insurance__c WHERE Id = :policy.Id];
		System.debug(policy);
        // Assert that the Insurance__c fields were updated correctly
        System.assertEquals('Test Policy Name' + String.valueOf(Datetime.now().formatGMT('yyyyMMddHHmmss')), policy.Name);
        System.assertEquals(customer.Id, policy.Customer__c);
        System.assertEquals(1000, policy.Annual_Premium_Amount__c);
        System.assertEquals('Health', policy.Insurance_Category__c);
        System.assertEquals('Default', policy.Company_Provider__c);
        System.assertEquals(10000, policy.Sum_Insured__c);
        // Add assertions for the other Insurance__c fields

        // Retrieve the created Payment__c record from the database
        Payment__c testPayment = [SELECT Card__c, Payment_Date_Time__c, Name, Payment_Day__c, Payment_By__c, Policy__c, Payment_Status__c, Payment_Source__c, Amount__c FROM Payment__c WHERE Payment_By__c = :customer.Id];
		System.debug(testPayment);
        // Assert that the Payment__c fields were set correctly
        System.assertEquals(card.Id, testPayment.Card__c);
        System.assertEquals(customer.Id, testPayment.Payment_By__c);
        //System.assertEquals(policy.Id, testPayment.Policy__c);
        System.assertEquals('Completed', testPayment.Payment_Status__c);
        System.assertEquals('Policy buy out', testPayment.Payment_Source__c);
       // System.assertEquals(1000, testPayment.Amount__c);
        // Add assertions for the other Payment__c fields

        // Retrieve the created Associated_Parties__c records from the database
        List<Associated_Parties__c> testAssociatedParties = [SELECT Name, Relationship__c, Policy__c, Gender__c, DOB__c, Education__c, Marital_Status__c, Type_Of_ID_Card__c, ID_Card_Number__c, Occupation__c, Nature_of_employment__c, Salary__c, salaries__c, Height_In_Cm__c, Weight_In_Kg__c, Blood_Group__c, Lifestyle_Habits__c, Email__c, Mobile__c, Address__c, City__c, State__c, Country__c, Zip_Code__c FROM Associated_Parties__c WHERE Policy__c = :policy.Id];
		System.debug('assos');
        System.debug(testAssociatedParties);
        // Assert that the Associated_Parties__c records were created correctly
        System.assertEquals(0, testAssociatedParties.size());
       // System.assertEquals('Test Name', testAssociatedParties[0].Name);
        //System.assertEquals('Insured', testAssociatedParties[0].Relationship__c);
        //System.assertEquals(policy.Id, testAssociatedParties[0].Policy__c);
        //System.assertEquals('Male', testAssociatedParties[0].Gender__c);
        //System.assertEquals(Date.valueOf('1990-01-01'), testAssociatedParties[0].DOB__c);
        // Add assertions for the other Associated_Parties__c fields
    }


    
}