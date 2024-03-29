@isTest
public class GenXTestClass {
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

}