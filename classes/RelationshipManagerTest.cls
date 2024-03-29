@isTest
public class RelationshipManagerTest {
    @isTest
    public static void updaterecTest(){
        Bank__c bank = new Bank__c();
        bank.Name = 'Test';
        bank.Manager__c='0055j00000BS0W2AAL';
        insert bank;
        
        List<Customers__c> c=new List<Customers__c>();
        Customers__c customer = new Customers__c();
        customer.Name = 'Test Customer';
        customer.Customer_Id__c = '7654321';
        customer.Bank__c = bank.Id;
        customer.Password__c = 'Anim@123';
        customer.User_name__c = 'tanimesh';
        customer.PAN__c = 'BTVPV4305A';
        customer.Date_of_Birth__c = Date.valueOf(System.now());
        customer.Mobile_Phone__c = '1234567890';
        customer.Zip_Code__c = 'Z467';
        customer.Is_Active__c=true;
        customer.Email__c = 'animesh.shrivastava@cognizant.com';
        insert customer;
        
        Customers__c custom = new Customers__c();
        custom.Name = 'Test_Customer';
        custom.Customer_Id__c = '8654321';
        custom.Bank__c = bank.Id;
        custom.Password__c = 'Anim@123';
        custom.User_name__c = 'tamimesh';
        custom.PAN__c = 'BTVPV4305A';
        custom.Date_of_Birth__c = Date.valueOf(System.now());
        custom.Mobile_Phone__c = '1234567892';
        custom.Zip_Code__c = 'Z467';
        custom.Is_Active__c=false;
        custom.Email__c = 'animesh.shrivastava@cognizant.com';
        insert custom;
        
        c.add(customer);
        c.add(custom);
        
        Test.startTest();
        RelationshipManagerHandler.updateInsertRec(c);
        //RelationshipManagerHandler.insertrec(c);
        Test.stopTest();
        
    }

}