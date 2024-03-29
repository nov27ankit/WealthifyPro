@isTest 
public class policyUpgradeControllerTest {
    
	@isTest 
   public static void policyUpgradeControllerTest(){
       //String jsonInput = '{"Lower_Bound_Age_del__c": 26, "Name_del__c": "Animesh" , "rng": {"nm":"R1","lB":20,"UB":25}}';
       PolicyUpgrade__c custsettingrecord =new PolicyUpgrade__c(Lower_Bound_Age_del__c=26,Name_del__c='Animesh',Range_Settings__c='{"rng": [{"nm":"R1"}]}' ,Upper_Bound_Age_del__c=40);
       insert custsettingrecord;
       // Create a Bank record  
  user c=new user(Email='ankit@gmail.com'); 
     
		Bank__c bank = new Bank__c(Name='ICCU' ,
  	  Manager__c=c.id);
   insert bank;

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
            
             Insurance__c testInsurance = new Insurance__c(
            Name = 'Test Insurance',
            Customer__c = customer.Id,
            Payment_Frequency__c = 'Monthly',
            Premium_Due_Date__c = Date.today().addDays(5),
            Type__c = 'Internal',Policy_Stage__c='Advanced',
           // Policy_Renewal_Date__c = Date.today().addMonths(12),
         Status__c='Active',
          Sum_Insured__c= 500000,
            Plan_Start_Date__c = Date.today().addDays(-500),
            Policy_Renewal_Date__c = Date.today().addDays(100)
        );
        insert testInsurance;
    
   
        List<Insurance__c> PolicyList = policyUpgradeController.basicToAdvanced(testInsurance.Id);
        System.assertEquals(1, PolicyList.size());
        List<Insurance__c> PolicyLis = policyUpgradeController.advancedTointegrated(testInsurance.Id);
        System.assertEquals(1, PolicyLis.size());
            
        
             policyUpgradeController.checkForIsEligible(testInsurance.Id,false,true);
            System.assertEquals(testInsurance.isEligibleForIntegrated__c,false);
             System.assertEquals(testInsurance.isEligibleForAdvanced__c,false);
       Object h=policyUpgradeController.ageCalculator(testInsurance.Id);
       System.debug(h);
       //System.assertEquals(2,h.size());
        }
    
    //{{one,0},{two,null}}
}