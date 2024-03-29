@isTest
public class InsuranceControllerTest {

    @isTest
    static void testInsuranceController() {
        // Create Admin data
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

        Associated_Parties__c testAP = new Associated_Parties__c(
            Policy__c = testInsurance.Id,
            Relationship__c = 'Beneficiary',
            Salaries__c = 10
        );
        insert testAP;
        
        Associated_Parties__c testPD = new Associated_Parties__c(
            Policy__c = testInsurance.Id,
            Relationship__c = 'Policyholder',
            Salaries__c = 20
        );
        insert testPd;

        AppDataController.DataWrapper testData = new AppDataController.DataWrapper();
        testData.insuranceMap = new Map<Id, Insurance__c>{testInsurance.Id => testInsurance};
        testData.customerMap = new Map<Id, Customers__c>{testCustomer.Id => testCustomer};
        testData.associatedPartiesMap = new Map<Id, List<Associated_Parties__c>>();

        Test.setCurrentPageReference(Page.generatepdf);
        ApexPages.currentPage().getParameters().put('recordId', testInsurance.Id);

        InsuranceController controller = new InsuranceController();
        controller.loadData();

        System.assertEquals(testInsurance.Id, controller.insureId);
        System.assertEquals(testInsurance.Customer__c, controller.customerId);
        System.assertEquals(testAP.Relationship__c, controller.ap.Relationship__c);
        System.assertEquals(testAP.Salaries__c, controller.ap.Salaries__c);
        System.assertEquals(testPD.Relationship__c, controller.pd.Relationship__c);
        System.assertEquals(testPD.Salaries__c, controller.pd.Salaries__c);
        
    }
}