public class RenewalReminderBatch implements Database.Batchable<SObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Return a QueryLocator for the policies meeting the criteria
        Date today = Date.today();
        Date renewalDate30 = today.addDays(30);
        Date renewalDate20 = today.addDays(20);
        Date renewalDate10 = today.addDays(10);
        Date renewalDate5 = today.addDays(5);
        Date renewalDate1 = today.addDays(1);
        System.debug('Before 1 day:'+renewalDate1);
        System.debug([SELECT Id, Payment_Status__c, Is_Renewal_Completed__c, Company_Provider__c, Policy_Renewal_Date__c, Email__c,Customer__r.Name, Status__c,Customer__r.Email__c
            FROM Insurance__c
            WHERE Payment_Status__c = 'Not Paid'
              AND Policy_Renewal_Date__c IN :new List<Date>{renewalDate30, renewalDate20, renewalDate10, renewalDate5, renewalDate1}
              AND Is_Renewal_Completed__c = false AND Status__c = 'Active']);
        
        return Database.getQueryLocator([
            SELECT Id, Payment_Status__c, Is_Renewal_Completed__c,Type__c,Payment_Frequency__c,Company_Provider__c,Plan_Term__c, Plan_Start_Date__c,Maturity_Date__c,Policy_Renewal_Date__c, Email__c, Customer__r.Name, Status__c,Customer__r.Email__c
            FROM Insurance__c
            WHERE Payment_Status__c = 'Not Paid'
              AND Policy_Renewal_Date__c IN :new List<Date>{renewalDate30, renewalDate20, renewalDate10, renewalDate5, renewalDate1}
              AND Is_Renewal_Completed__c = false AND Status__c = 'Active'
        ]);
    }
    
        

    public void execute(Database.BatchableContext context, List<Insurance__c> policies) {
        System.debug('Policies in execute...');
        System.debug('Maturity date in execute:'+policies[0].Maturity_Date__c);
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        OrgWideEmailAddress orgWideEmailAddress = [SELECT Id 
                                                   FROM OrgWideEmailAddress 
                                                   WHERE DisplayName = 'genxsupport@salesforce.com'];
        
        for (Insurance__c policy : policies) {
            String companyProvider='Not Mentioned';
            if(policy.Company_Provider__c!=null)
                    companyProvider=policy.Company_Provider__c;
            // Prepare and send renewal reminder email
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            String body = 'Hello ' + policy.Customer__r.Name + ',<br><br>' +
              'Your policy with ' + companyProvider + ' is due for renewal on ' + policy.Policy_Renewal_Date__c.format() + '.<br>' +
              'If you are looking for any modification in your existing policy or have any query regarding your policy, kindly connect with our helpdesk.<br><br>' +
              'Thanks<br><br>' +
              'Regards,<br>' + policy.Company_Provider__c;
            System.debug(body);
            email.setToAddresses(new List<String>{ policy.Customer__r.Email__c   });
            email.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
            email.setSubject('Policy Renewal Reminder');
            email.setHtmlBody(body);
            emailsToSend.add(email);
        }
            // Send emails
            System.debug('Emails List size:'+emailsToSend.size());
            if(emailsToSend.size() > 0){
                try{
                Messaging.SendEmailResult[] sendResult = Messaging.sendEmail(emailsToSend);
    
                if (sendResult[0].isSuccess()) {
                    System.debug('Email sent successfully.');
                } else {
                    // Handle errors
                    for (Messaging.SendEmailError error : sendResult[0].getErrors()) {
                        System.debug('Email send failed: ' + error.getMessage());
                    }
                }
            }
                catch (Exception e){
            System.debug('Error while sending an email'+e.getMessage());
        }
                
            }
    }

    public void finish(Database.BatchableContext context) {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :context.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
    }
    
    // Execute at regular intervals
    public void execute(SchedulableContext ctx){
      RenewalReminderBatch batch = new RenewalReminderBatch();
      Database.executebatch(batch, 200);
    }
}