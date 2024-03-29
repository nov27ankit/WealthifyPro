@isTest
public class emailtriggerhandlerTest {
    @isTest
    
    public static void emailNotificationTest(){
        Bank__c bank = new Bank__c();
        bank.Name = 'Test';
        insert bank;
        
        List<Customers__c> cList = new List<Customers__c>();
        Map<id,Customers__c> oldmap = new Map<id,Customers__c>();
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.Customer_Id__c = '2129118';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Vignesh@123';
        customer.User_name__c = 'vignesha';
        customer.PAN__c = 'EWWPD6727H';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.last_change_date__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Email__c = 'vignesh.a29a32e@cognizant.com';
        insert customer;
        
        customer.Password__c = 'Vignesh@127';
        update customer;
        
        clist.add(customer);
        oldmap.put(customer.Id, customer);
        
        Test.startTest();
        emailtriggerhandler.passwordchangedate(clist,oldmap);
        Test.stopTest();
        
    }
    
}