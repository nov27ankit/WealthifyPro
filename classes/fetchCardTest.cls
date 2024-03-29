@isTest
public class fetchCardTest {
    @isTest
    public static void fetchCardTest(){
        // Create a Bank record
        Bank__c bank = new Bank__c(Name='ICICU');
        insert bank;

        // Create a Customers record
        Customers__c customer = new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c='1234567',
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
        
        //policy
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

        // Create a Card record
        Card__c card = new Card__c(
            Name = 'animesh',
            Card_Network__c = 'Visa',
            Card_Number__c = '6789564367890654',
            Customer__c = customer.Id,
            CVV__c = 123,
            Expiry_Date__c = Date.valueOf(System.today()),
            Is_This_Primary_Card__c = true,
            Select_your_Bank__c = bank.Id,
            Status__c = 'active',
            Type__c = 'Debit'
        );
        insert card;
             Insurance__c testInsurance = new Insurance__c(
            Name = 'Test Insurance',
            Customer__c = customer.Id,
            Payment_Frequency__c = 'Monthly',
            Premium_Due_Date__c = Date.today().addDays(5),
            Type__c = 'Internal',
            Policy_Renewal_Date__c = Date.today().addMonths(12)
        );
        insert testInsurance;

        // Test cCard method
        List<Card__c> allcard = fetchCard.cCard(customer.Id);
        System.assertEquals(1, allcard.size());

        // Test creditCard method
        List<Card__c> allcar = fetchCard.creditCard(customer.Id);
        System.assertEquals(1, allcar.size());

        // Test filter method
        List<Card__c> allca = fetchCard.filter(customer.Id, 'Debit', 'animesh', 'IC', 'Visa', null);
        System.assertEquals(1, allca.size());
        
        // Test primaryCard method
        Test.startTest();
        fetchCard.primaryCard(card.Id);
        Test.stopTest();

        // Query the updated Card record after calling primaryCard method
        Card__c updatedCard = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id = :card.Id];
        System.assertEquals(true, updatedCard.Is_This_Primary_Card__c);

        // Test getAccounts method
        fetchCard.Wrapper accountData = fetchCard.getAccounts(customer.Id);
        System.assertEquals(1, accountData.res1.size());
        System.assertEquals(1, accountData.res2.size());

        // Test policy method
        //Insurance__c insurancePolicy = fetchCard.policy(customer.Id);
        //System.assertNotEquals(null, insurancePolicy);

       // Test pay method
        Payment__c payment = fetchCard.pay(customer.Id, 100, card.Id, policy.Id, policy, 100);
        //System.assertNotEquals(1, payment.size());

         //Test filterpay method
        List<Payment__c> filteredPayments = fetchCard.filterpay(customer.Id, 'Name', '2023-01-01', 'Completed');
        System.assertEquals(0, filteredPayments.size());
        
        

       

       
        
    }
     @isTest
    public static void fetchCardTest1(){
        // Create a Bank record
        Bank__c bank = new Bank__c(Name='ICICU');
        insert bank;

        // Create a Customers record
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

        // Test filterClaim method
        List<Claim__c> filteredClaims = fetchCard.filterClaim(customer.Id, 'Status');
        
        // Assert that the returned list is empty
        System.assertEquals(0, filteredClaims.size());

    }
   @isTest
    static void testFilterpay() {
        // Test data setup
        Account account = new Account(Name = 'Test Account');
        insert account;
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

        Payment__c payment = new Payment__c(
            Amount__c = 1000,
            Card__c = card.Id,
            Payment_By__c = customer.Id,
            Payment_Status__c = 'Pending',
            Policy__c = policy.Id
        );
        insert payment;

        /* Test with valid parameters
        List<Payment__c> result = fetchCard.filterpay(customer.Id, policy.Name, null, 'Pending');
        System.assertEquals(1, result.size());

        // Test with invalid parameters (modify as needed)
        result = fetchCard.filterpay(account.Id, 'Invalid Policy', null, 'Completed');
        System.assertEquals(0, result.size());*/

        // Test with null or blank parameters (modify as needed)
        List<Payment__c> result = fetchCard.filterpay(null, null, null, null);
        System.assertEquals(0, result.size());
    }
}