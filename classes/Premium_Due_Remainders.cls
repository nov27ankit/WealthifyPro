global class Premium_Due_Remainders implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String status='Active';
        //String paymentStatus='Not Paid';
        System.debug('inside start');
        String insurance = 'SELECT Id, Name, Customer__c, Maturity_Date__c, Company_Provider__c, Monthly_Premium_Amount__c, Premium_Due_Date__c, Status__c, Payment_Status__c FROM Insurance__c WHERE Status__c = :status  AND Premium_Due_Date__c!=Null';
        return Database.getQueryLocator(insurance);//returns list of Insurance records which are need to send remainders
    }
    //finding remainder type based on due date and storing them in different lists
    List<Insurance__c> insuranceUpdate = new List<Insurance__c>(); 
   	Map<Insurance__c,ID> remainder15=new Map<Insurance__c,ID>();
    Map<Insurance__c,ID> remainder7=new Map<Insurance__c,ID>();
    Map<Insurance__c,ID> remainder3=new Map<Insurance__c,ID>();
    Map<Insurance__c,ID> remainder1=new Map<Insurance__c,ID>();
    Map<Id,String> customerEmail =new Map<Id, String>();
    Map<Id,String> customerName = new Map<Id, String>();
    global void execute(Database.BatchableContext BC, List<Insurance__c> scope) {
    
		System.debug('Inside Execute and data is :'+scope);
        system.debug('listsize'+scope.size());
                   System.debug('today date:'+Date.today());
                           System.debug('today date:'+Date.today().addDays(15));
        //list<Insurance__c> update= new list <Insurance__c>();
            List<Insurance__c> recordsToUpdate = new List<Insurance__c>();
    	for(Insurance__c insurance : scope){//Iterates each Insurance record and checks for duedate of each record
            Date startDate = Date.today();
           // System.debug('today date:'+startDate);

			Date endDate = insurance.Premium_Due_Date__c;	
            Integer diff=startDate.daysBetween(endDate);
            // System.debug('days difference:'+diff);

            if(diff==15){//if the duedate is within 15days then add it remainder15 list
                System.debug(endDate.daysBetween(startDate));
                System.debug('Remainder 1 -Days gap is 15 from due date');
                System.debug('payment status b4 updating'+insurance.Payment_Status__c);
                                insurance.Payment_Status__c='Not Paid';
                system.debug('name'+insurance.Name);
                System.debug('payment status after updating'+insurance.Payment_Status__c);
                insuranceUpdate.add(insurance);
                            update insuranceUpdate;
                remainder15.put(insurance,insurance.Customer__c);
            }

            if(diff==7){//if the duedate is within 7 days then add it remainder7 list
                System.debug(endDate.daysBetween(startDate));
                System.debug('Remainder 2 -Days gap is 7 from due date');
                remainder7.put(insurance,insurance.Customer__c);
            }
            if(diff==3){//if the duedate is within 3 days then add it remainder3 list
                System.debug(endDate.daysBetween(startDate));
                System.debug('Remainder 3 -Days gap is 3 from due date');
                remainder3.put(insurance,insurance.Customer__c);
            }
            if(diff==1){//if the duedate is within 1 days then add it remainder1 list
                System.debug(endDate.daysBetween(startDate));
                System.debug('Final Remainder -Days gap is 1 from due date');
                remainder1.put(insurance,insurance.Customer__c);
            }
    	}
        
        List<Customers__c> customer = [Select Id, Name, Email__c from Customers__c where Id in :remainder15.values() or Id in :remainder7.values() or Id in :remainder3.values() or Id in :remainder1.values()];
        for(Customers__c cust : customer){
            customerEmail.put(cust.Id, cust.Email__c);
            customerName.put(cust.Id, cust.Name);
        }
        
        Map<String,String> emailBody=new Map<String,String>();
        if(remainder15.size()>0){//Now iterate through each map and the send email 
        	for(Insurance__c insurance: remainder15.keyset()){
                String PremiumAmount='Not Mentioned';
                String companyProvider='Not Mentioned';
                                insurance.Payment_Status__c='Not Paid';

                if(insurance.Monthly_Premium_Amount__c!=null)
                    premiumAmount=String.valueOf(insurance.Monthly_Premium_Amount__c);
                if(insurance.Company_Provider__c!=null)
                    companyProvider=insurance.Company_Provider__c;
            	String body='Hello ' +customerName.get(remainder15.get(insurance))+ 
                                ',\n\nYour payment of Rs.'+PremiumAmount+' for Plan '+insurance.Name+' due date is approaching on '+insurance.Premium_Due_Date__c.format()+'. Please pay your premium in time and ensure to continue your policy.\n\n If any queries , please contact our customer executive toll free number.\n\nThanks\n\nRegards,\n'
                                +companyProvider;
    
                genXBankController.sendEmailToCustomer(customerEmail.get(remainder15.get(insurance)),body,'Urgent : 1st Reminder: Premium Due For Your Policy');
                System.debug('Email Sent Sucessfully');//subject body and emailid is passed as a parameters to send email
            }
        }
        if(remainder7.size()>0){
            
        	for(Insurance__c insurance: remainder7.keyset()){
                String PremiumAmount='Not Mentioned';
            	String companyProvider='Not Mentioned';
                if(insurance.Monthly_Premium_Amount__c!=null)
                    premiumAmount=String.valueOf(insurance.Monthly_Premium_Amount__c);
                if(insurance.Company_Provider__c!=null)
                    companyProvider=insurance.Company_Provider__c;
                
            	String body='Hello ' +customerName.get(remainder7.get(insurance))+ 
                                ',\n\nYour payment of Rs.'+premiumAmount+' for Plan '+insurance.Name+' due date is approaching on '+insurance.Premium_Due_Date__c.format()+'. Please ensure to continue your policy, you pay your premium on time. If any queries , please contact our customer executive toll free number.\n\nThanks\n\nRegards,\n'
                                +companyProvider;
                genXBankController.sendEmailToCustomer(customerEmail.get(remainder7.get(insurance)),body,'Urgent : 2nd Reminder: Premium Due For Your Policy');
                System.debug('Email Sent Successfully');
            }
        }
        if(remainder3.size()>0){
           
        	for(Insurance__c insurance: remainder3.keyset()){
                 String PremiumAmount='Not Mentioned';
                String companyProvider='Not Mentioned';
                if(insurance.Monthly_Premium_Amount__c!=null)
                    premiumAmount=String.valueOf(insurance.Monthly_Premium_Amount__c);
                if(insurance.Company_Provider__c!=null)
                    companyProvider=insurance.Company_Provider__c;
                
            	String body='Hello ' +customerName.get(remainder3.get(insurance))+ 
                                ',\n\nYour payment of Rs.'+premiumAmount+' for Plan '+insurance.Name+' due date is approaching on '+insurance.Premium_Due_Date__c.format()+'. Please ensure to continue your policy, you pay your premium on time. If any queries , please contact our customer executive toll free number.\n\nThanks\n\nRegards,\n'
                                +companyProvider;
                genXBankController.sendEmailToCustomer(customerEmail.get(remainder3.get(insurance)),body,'Urgent : 3rd Reminder: Premium Due For Your Policy');
                System.debug('Email Sent Sucessfully');
            }
        }
        if(remainder1.size()>0){
            
        	for(Insurance__c insurance: remainder1.keyset()){
                String PremiumAmount='Not Mentioned';
                String companyProvider='Not Mentioned';
                if(insurance.Monthly_Premium_Amount__c!=null)
                    premiumAmount=String.valueOf(insurance.Monthly_Premium_Amount__c);
                if(insurance.Company_Provider__c!=null)
                    companyProvider=insurance.Company_Provider__c;
                
            	String body='Hello ' +customerName.get(remainder1.get(insurance))+ 
                                ',\n\n    Your payment of Rs.'+premiumAmount+' for Plan : '+insurance.Name+' due date is approaching on '+insurance.Premium_Due_Date__c.format()+'. Please ensure to continue your policy, you pay your premium on time.\n\n If any queries , please contact our customer executive toll free number.\n\nThanks\n\nRegards,\n'
                                +companyProvider;
            
                genXBankController.sendEmailToCustomer(customerEmail.get(remainder1.get(insurance)),body,'Urgent : Final Reminder: Premium Due For Your Policy');
                System.debug('Email Sent Sucessfully');
                
            }
        }
}  

    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext SC) {
        Premium_Due_Remainders pdr= new Premium_Due_Remainders();
		Database.executeBatch(pdr, 1000);
    }
    

}