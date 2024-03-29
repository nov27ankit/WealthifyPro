global class Missed_Premium_Remainder implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC){
        //String status = 'Active';
        //String lapseStatus = 'Hibernate';
        List<String> status = new List<String>{'Active', 'Hibernate'};
        String paymentStatus = 'Not Paid';
        String insurance = 'SELECT Id, Name, Customer__c, Maturity_Date__c, Company_Provider__c, Monthly_Premium_Amount__c, Premium_Due_Date__c, Status__c, Payment_Status__c,Status_Reason__c FROM Insurance__c WHERE Status__c in :status AND Payment_Status__c =:paymentStatus AND Premium_Due_Date__c<=today';
        return Database.getQueryLocator(insurance);
    }
    
    Map<Insurance__c, Id> remainder = new Map<Insurance__c, Id>();
    Map<Insurance__c, Id> remainder3 = new Map<Insurance__c, Id>();
    //Map<Insurance__c, Id> remainder30 = new Map<Insurance__c, Id>();
    List<Insurance__c> insuranceUpdate = new List<Insurance__c>(); 
    Map<Id, String> customerEmail = new Map<Id, String>();
    Map<Id, String> customerName = new Map<Id, String>();    
    global void execute(Database.BatchableContext BC, List<Insurance__c> scope){
        for(Insurance__c insurance : scope){
            Date todayDate = Date.today();
            Date premiumDueDate = insurance.Premium_Due_Date__c;
            Integer daysDiff = premiumDueDate.daysBetween(todayDate);
            System.debug('Days Difference'+daysDiff);
            if(daysDiff>=1 && daysDiff<=3){
                if(insurance.Status__c!='Hibernate'){
                insurance.Status__c='Hibernate';
            	}
                remainder.put(insurance, insurance.Customer__c);
                System.debug(remainder);
                system.debug(insurance.Name);
            }	
            /*if(daysDiff>=16 && daysDiff<=30){
                //insurance.Monthly_Premium_Amount__c*=1.01;
                System.debug(daysDiff);
                remainder16.put(insurance, insurance.Customer__c);
                System.debug('Remainder 16'+remainder16.size());
            }*/
            if(daysDiff>3){
                if(insurance.Status__c!='Lapsed'){
                    insurance.Status__c = 'Lapsed';
                    //insurance.Status_Reason__c='No Premium Paid';
                }
                remainder3.put(insurance, insurance.Customer__c);
            }
            System.debug('Remainder size is '+remainder3.size());
            insuranceUpdate.add(insurance);
        }
        
        if(insuranceUpdate.size() > 0){
            update insuranceUpdate;
            System.debug('Updated insurance:'+insuranceUpdate[0].Status__c);
        }
        
        List<Customers__c> customer = [Select Id, Name, Email__c from Customers__c where Id in: remainder.values()];
        for(Customers__c cust : customer){
            customerEmail.put(cust.Id, cust.Email__c);
            customerName.put(cust.Id, cust.Name);
        }
        
        Map<String, String> emailbody = new Map<String, String>();
        
        if(remainder.size()>0){
            for(Insurance__c insurance : remainder.keySet()){
       			String premiumAmount = 'Not Mentioned';
                
            	String insuranceProvider = 'Not Mentioned';
            	if(insurance.Monthly_Premium_Amount__c!=null){
            		premiumAmount = String.valueOf(insurance.Monthly_Premium_Amount__c);
				}
            	if(insurance.Company_Provider__c!=null){
            		insuranceProvider = insurance.Company_Provider__c;
        		}
            	String body = 'Hello ' +customerName.get(remainder.get(insurance))+ '\n\nYou have missed your premium payment of Rs. ' +premiumAmount+ ' for plan ' +insurance.Name+ '. Please pay your premium or else your policy will become lapsed in 3 days.\n\nThanks and Regards,\n'+insuranceProvider;
            	genXBankController.missedPremiumEmail(customerEmail.get(remainder.get(insurance)), body, 'Urgent : Final Reminder: Premium Due For Your Policy');
			}
        }
        
        /*if(remainder16.size()>0){
            for(Insurance__c insurance : remainder16.keySet()){
              
                String premiumAmount = 'Not Mentioned';
            	String insuranceProvider = 'Not Mentioned';
                Decimal premiumWithPenalty = 0;
                if(insurance.Monthly_Premium_Amount__c!=null){
                    premiumAmount = String.valueOf(insurance.Monthly_Premium_Amount__c);
                    premiumWithPenalty = decimal.ValueOf(premiumAmount)*1.01;
                    System.debug(premiumWithPenalty);
                }
                if(insurance.Company_Provider__c!=null){
                    insuranceProvider = insurance.Company_Provider__c;
                }
                String body = 'Hello' +customerName.get(remainder16.get(insurance))+ '\n\n We want to bring to your attention that your policy ' +insurance.Name+ ' is in hibernate. If you wish to continue with your policy , Kindly contact customer service helpdesk and pay the premium amount of Rs. ' +premiumWithPenalty+ 'within 15 days.\n\n Thanks and Regards,\n'+insuranceProvider;
                genXBankController.missedPremiumEmail(customerEmail.get(remainder16.get(insurance)), body, 'Missed Premium Payment');
            }
            
        }*/
        if(remainder3.size()>0){
            for(Insurance__c insurance : remainder3.keySet()){
                String premiumAmount = 'Not Mentioned';
            	String insuranceProvider = 'Not Mentioned';
                System.debug('Size of Remainder3'+remainder3.size());
                if(insurance.Monthly_Premium_Amount__c!=null){
                    premiumAmount = String.valueOf(insurance.Monthly_Premium_Amount__c);
                }
                if(insurance.Company_Provider__c!=null){
                    insuranceProvider = insurance.Company_Provider__c;
                }
                String body = 'Hello' +customerName.get(remainder3.get(insurance))+ '\n\n Your policy ' + insurance.Name+ ' was lapsed, as you missed the grace period for paying the premium amount. Sorry to see you go';
                genXBankController.missedPremiumEmail(customerEmail.get(remainder3.get(insurance)), body, 'Missed Premium Payment');
            }            	
        }
    }
    
    
    global void finish(Database.BatchableContext BC) {
    }
    
    global void execute(SchedulableContext SC){
        Missed_Premium_Remainder pdr= new Missed_Premium_Remainder();
		Database.executeBatch(pdr, 100);
    }
}