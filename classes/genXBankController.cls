public with sharing class genXBankController {
    // S-0059 Ujjwala Chavan
    @AuraEnabled(cacheable=true)
    public static boolean getCustomerDetails(String name, String customerId, String mobileNumber, String password){
        List<First_Registration_Details__mdt> registrationDetails =[SELECT Id, Name__c, Customer_Id__c, Default_Password__c, Mobile_Number__c FROM First_Registration_Details__mdt WHERE Name__c =: name and Customer_Id__c =: customerId and Default_Password__c =: password and Mobile_Number__c =: mobileNumber];
        
        // Checking if customer details matches with existing database
        if(registrationDetails.size() != 0) {
            // Returning true if details matched
            return true;
        }
        else{
            // Returning false if details does not match
            return false;
        }
    }
    
    // S-0059 Ujjwala Chavan
    @AuraEnabled(cacheable=true)
    public static boolean existingCustomerCheck(String customerId){
        List<Customers__c> customerRecord = [SELECT Id, Customer_Id__c FROM Customers__c WHERE Customer_Id__c=:customerId];
        // Checking for existing customer record
        if(customerRecord.size() != 0){
            // Returning true if there exist record with passed customerId
            return true;
        }
        // Returning false if there is no record in the database with passed customerId
        return false;
    }
    
    // S-0175 Ujjwala Chavan & S-0171 H S Sagar
    @AuraEnabled
    public static void updateCardStatus(List<ID> selectedRowIds){
        System.debug('Selected Rows:'+ selectedRowIds);
        List<Card__c> cardDetails = new List<Card__c>();
        cardDetails = [SELECT Id, Status__c, Customer__c FROM Card__c WHERE Id in : selectedRowIds];
        System.debug(cardDetails);
        List<Card__c> cardList = new List<Card__c>();
        for (Card__c cardDetail : cardDetails) {
            System.debug('Card Details:'+cardDetail);
            cardDetail.Status__c = 'Inactive';
            cardList.add(cardDetail);
        }
        System.debug('Size:'+cardList.size());
        
        if(cardList.size() > 0){
            update cardList;
        }
        //return [SELECT Id, Account_Number__c, Available_Card_Limit__c, Name, Card_Number__c,  Customer__c,CVV__c,Email_Address__c,Select_your_Bank__r.Name,Status__c,Total_Card_Limit__c,Type__c,Expiry_Date__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: cardList[0].Customer__c AND Status__c='Active'];
    }
    
    // //S-0062 Vignesh A
    // @AuraEnabled(cacheable=true)
    // public static List<Customers__c> getCustomRecords(){
    //     return [SELECT Id, Customer_Id__c, User_name__c, Password__c,Email__c , Date_of_Birth__c, PAN__c FROM Customers__c];
    // } 
    
    @AuraEnabled(cacheable=true)
    public static boolean getCustomermetaDetails(String password){
        List<First_Registration_Details__mdt> registrationDetails = [SELECT Id, Default_Password__c FROM First_Registration_Details__mdt limit 1];
        
        for(First_Registration_Details__mdt frd : registrationDetails){
            // Checking if customer details matches with existing database
            if(password.equals(frd.Default_Password__c)){
                // Returning true if details matched
                return true;
            }
        }
        // Returning false if details does not match
        return false;
    }
    
    // Ameer Sulaiman
    @AuraEnabled(cacheable=true)
    public static List<Customers__c> getCustDetails(String mobilenumber){
        return [SELECT Id, Customer_Id__c, User_name__c, Email__c, Mobile_Phone__c From Customers__c Where Mobile_Phone__c=:mobilenumber];
    }
    
    //S-0068 Bibhor Kumar
    @AuraEnabled(cacheable=true)
    public static List<Customers__c> getCustomerRecords(String pan, String emailId, Date dob){
        return [SELECT Id, Customer_Id__c, User_name__c, Password__c,Email__c , Date_of_Birth__c, PAN__c FROM Customers__c WHERE PAN__c=:pan AND Email__c =:emailId AND Date_of_Birth__c =:dob];
    }
    
    //S-0069 Rameshwari Mane
    @AuraEnabled(cacheable=true)
    public static void sendUsernameEmail(String emailAddress, String username, String customerId) {
        //Query to get customer details
        List<Customers__c> customer = [SELECT Id, Bank__r.Name, Name, Customer_Id__c, User_name__c 
                                       FROM Customers__c 
                                       WHERE User_name__c =: username];
        System.debug('customer '+customer);
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { emailAddress };
            email.setToAddresses(toAddresses);
        email.setSubject('Information requested by ' + customer[0].Name + ' from '+customer[0].Bank__r.Name);
        email.setPlainTextBody('Hello ' +customer[0].Name+ 
                               ',\n\nPlease find the username  and Customer ID information requested by you.\n\nUsername: '
                               + username + '\nCustomer ID: ' + customerId + '\n\nRegards,\n'
                               +customer[0].Bank__r.Name);
        
        OrgWideEmailAddress orgWideEmailAddress = [SELECT Id 
                                                   FROM OrgWideEmailAddress 
                                                   WHERE DisplayName = 'genxsupport@salesforce.com'];
        
        email.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
        System.debug('Email '+email);
        try{ 
            //Send an email  
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if (sendResults[0].isSuccess()) {
                System.debug('Email sent successfully.');
            } else {
                System.debug('Email sending failed: ' + sendResults[0].getErrors()[0].getMessage());
            }
        }catch(Exception e){
            System.debug('Email sending exception : '+e.getMessage());
        }
    }
   @AuraEnabled(cacheable=true)
public static String fetchRecordType(String recordTypeName){
    List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Insurance__c' AND Name = :recordTypeName LIMIT 1];

    if (!recordTypes.isEmpty()) {
        RecordType inc = recordTypes[0];
        System.debug('@@@Record Type Name: ' + recordTypeName);
        System.debug('@@@Insurance: ' + inc);
        System.debug('@@@Insurance Record Type Id: ' + inc.Id);
        return inc.Id;
    } else {
        // Handle the case when no records are found
        System.debug('@@@No Record Type found for: ' + recordTypeName);
        return null;
    }
}

    
    //S-0071 Animesh Shrivastava
    @AuraEnabled(cacheable=true)
    public static void sendPasswordEmail(String emailAddress, String username, String customerId) {
        //Query to get customer details
        List<Customers__c> customer = [select Id, Bank__r.Name, Name,Password__c, Relationship_manager__c,Customer_Id__c, User_name__c from Customers__c where User_name__c =: username];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { emailAddress };
            email.setToAddresses(toAddresses);
        //email.setSenderDisplayName('GenX Bank');
        email.setSubject('Information requested by ' + customer[0].Name + ' from '+customer[0].Bank__r.Name);
        email.setPlainTextBody('Hello ' +customer[0].Name+ ',\n\nPlease find the password information for ' + username + ' Requested by you \n\n password : ' + customer[0].Password__c +'\n\nRegards,\n'+customer[0].Relationship_manager__c);
        email.setOrgWideEmailAddressId('0D25i000000wlArCAI');
        try{ 
            //Send an email  
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if (sendResults[0].isSuccess()) {
                System.debug('Email sent successfully.');
            } else {
                System.debug('Email sending failed: ' + sendResults[0].getErrors()[0].getMessage());
            }
        }catch(Exception e){
            System.debug('Email sending exception : '+e.getMessage());
        }
    }
    //S-0077 Mohan Javvaji
    @AuraEnabled(Cacheable=true)
    public static boolean sendEmail(ID customerId,String EmailId, String OTP){
        System.debug('Customer iD'+customerId+'EmailId '+EmailId+' OTP '+OTP);
        System.debug('INSIDE Email method');//Retriving customer details based on ID
        Customers__c customer=[Select ID,User_name__c,Email__c,Mobile_Phone__c from Customers__c where ID=:customerId][0];
        if(EmailId!=customer.Email__c)
            return false;// If user Enters Email Id mismatches with user registered email Method terminates.
        System.debug(EmailId+'printing'+OTP);
        List<String> sendingTo=new List<String>();
        sendingTo.add(EmailId);//Storing Email Id of user as a list
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='genxsupport@salesforce.com'];
        if(owea!=null) {
            semail.setOrgWideEmailAddressId(owea.Id);//Sending Email to user from Organization Email
        }
        semail.setToAddresses(sendingTo);
        semail.setSubject('OTP Verification');
        semail.setPlainTextBody('Your 6 digit OTP is '+ OTP);//Sending Email to User Email ID
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        return true;
    }
    //S-0077 Mohan Javvaji
    @AuraEnabled
    public static boolean Validate_Update(ID customerId,String userName, String mobileNumber,String emailId, String userOtp, String otp){
        System.debug(customerId+'cid'+userName+' un '+mobileNumber+' mn '+userOtp+' uo '+ otp);
        Customers__c customer=[Select ID,User_name__c,Email__c,Mobile_Phone__c from Customers__c where ID=:customerId][0];
        System.debug(customer);//Retriving Customer details to validate based on customerID
        if(userName==customer.User_name__c && emailId==customer.Email__c && userOtp==otp){
            customer.Mobile_Phone__c=mobileNumber;//If Validation results true then mobile number updates here.
            
            return true;//and method terminates here.
        }
        return false;// If validation fails then it returns false which results mobile number not updated
    }
    
    //S-0083 Sai Chandana Nandigama
    @AuraEnabled(Cacheable=true)
    public static boolean sendEmailAfterSignUp(ID custID) {
        //Query to get customer details
        List<Customers__c> customer = [select Id, Bank__r.Name,Email__c, Name, Relationship_manager__c,Customer_Id__c, User_name__c from Customers__c where ID =: custID];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { customer[0].Email__c };
            email.setToAddresses(toAddresses);
        email.setSubject('Successful SignUp!');
        email.setPlainTextBody('Hello ' +customer[0].Name+ '\n\nYour sign up is successful. Please keep your profile updated and enjoy the banking.\n\nRegards,\n'+customer[0].Bank__r.Name);
        
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='genxsupport@salesforce.com'];
        if(owea!=null) {
            email.setOrgWideEmailAddressId(owea.Id);
        }
        // try{ 
        //Send an email 
        
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        if (sendResults[0].isSuccess())
        {
            System.debug('Email sent successfully.');
            return true;
        }
        
        /* }
catch(Exception e){
System.debug('Email sending exception : '+e.getMessage());
}*/
        return false;
    }
    //S-0074 Ameer Sulaiman
    @AuraEnabled(cacheable=true)
    public static void sendEmailAfterReset(String customerIdorUsername){
        // Query to get particular customer details based on user input
        List<Customers__c> cust = [Select Id, Name, User_name__c, Email__c, Customer_Id__c, Relationship_manager__c From Customers__c Where Id =:customerIdorUsername];
        String[] toAddress = new String[] {cust[0].Email__c};
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddress);
        email.setSubject('Password reset successful for '+cust[0].User_name__c);
        email.setPlainTextBody('Hello '+cust[0].Name+',\n\n Password reset successfully for '+cust[0].User_name__c+'\n\nRegards,\n'+cust[0].Relationship_manager__c);  
        // Query to get Organization Wide Address
        OrgWideEmailAddress owa = [Select Id From OrgWideEmailAddress Where DisplayName='genxsupport@salesforce.com'];
        email.setOrgWideEmailAddressId(owa.Id);    
        try{
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if(sendResults[0].isSuccess()){
                System.debug('Email sent successfully.');
            }
            else{
                System.debug('Email sending failed: ' + sendResults[0].getErrors()[0].getMessage());
            }
        }
        catch(Exception e){
            System.debug('Email sending exception'+e.getMessage());
        }
    }
    public static void sendEmailToCustomer(String emailId, String body, String Subject){
        List<String> sendingTo=new List<String>();
        sendingTo.add(emailId);//Storing Email Id of user as a list
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='genxsupport@salesforce.com'];
        if(owea!=null) {
            semail.setOrgWideEmailAddressId(owea.Id);//Sending Email to user from Organization Email
        }
        semail.setToAddresses(sendingTo);
        semail.setSubject(Subject);
        semail.setPlainTextBody(body);//Sending Email to User Email ID
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }
        catch(Exception e){
            System.debug('Error while sending email');
        }
        System.debug('Called Email sent Successfully and Email : '+emailId+' Subject : '+Subject+' body : '+body);
    }
    //S-0219 Ameer Sulaiman
    public static void missedPremiumEmail(String emailId, String body, String subject){
        List<String> recipient = new List<String>();
        recipient.add(emailId);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='genxsupport@salesforce.com'];
        if(owea!=null){
            email.setOrgWideEmailAddressId(owea.Id);
        }
        email.setToAddresses(recipient);
        email.setSubject(subject);     
        email.setPlainTextBody(body);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        catch(Exception e){
            System.debug('Error sending mail');
        }
    }
    //MADHURIMA
    @AuraEnabled
    public static List<CustomQuotes__c> getQuotesDetails(Integer age, Integer sal, Integer sum, String hab,double bmi,String cat){
        
        List<CustomQuotes__c> AllDetails =[SELECT Name,Quote_Number__c,Insurance_Category__c FROM CustomQuotes__c WHERE maximum_age__c >: age AND minimum_age__c <: age AND Min_BMI__c <: bmi AND Max_B__c >: bmi   AND Max_Salary__c>: sal AND Min__c <: sal AND Min_Sum_Insured__c<: sum AND Max_Sum_Insured__c>: sum AND Lifestyle_Habits__c=: hab AND Insurance_Category__c =: cat];
        //  
        System.debug('AllDetails');
        return AllDetails ; 
        
        
    }
    
    //Ameer Sulaiman
    //@AuraEnabled(cacheable=true)
    /*public static boolean contactUsEmail(String subject, String body, String name,String emailId){
        boolean result = false;
       List<String> recipient = new List<String>();  // the reciever   ///genx
    recipient.add(emailId);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='genxsupport@salesforce.com'];
      //the sender   //tw
        if(owea!=null){
          //  email.setOrgWideEmailAddressId(emailId);
        //   recipient.add(owea[0].Address);
         email.setOrgWideEmailAddressId(owea.Id);
        }
        system.debug('emailId'+emailId);
      //  system.debug('owea[0].Address',owea[0].Address);
        email.setToAddresses(recipient);
        email.setSubject(subject);     
        email.setPlainTextBody(body);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            result = true;
        }
        catch(Exception e){
            System.debug('Error sending mail');
        }
        return result;
        
    }*/
    // H S Sagar for updating purpose writting the method here in this apex class
    @AuraEnabled(cacheable=true)
    public static void updateSignedInStatus(ID customerID) {
       /* List<Insurance__c> policies = [SELECT Id, Status__c, Insurance_Category__c, Customer__c FROM Insurance__c WHERE Status__c='Lapsed' AND Customer__c=:customerID];
        List<Insurance__c> policiesToUpdate = new List<Insurance__c>();
        for (Insurance__c policy:policies) {
            policy.lapsed_declaratioon_signed__c = true;
            policiesToUpdate.add(policy);
        }
        if (policiesToUpdate.size() > 0){
            update policiesToUpdate;
        }*/
       Customers__c updatesign = [SELECT Id,lapsed_declaratioon_signed__c FROM Customers__c WHERE Id = :customerID ];
        if(updatesign != null)
        {
            updatesign.lapsed_declaratioon_signed__c=true;
            update updatesign;
		}
    }
    //Ameer Sulaiman
    /*@AuraEnabled(cacheable=true)
public static void saveFeedback(String customerFeedback, String customerId){
Customers__c customerRecord = [SELECT Id, Notes__c FROM Customers__c WHERE Id=:customerId LIMIT 1];
if(customerRecord!=null){
String updatedNotes;
String existingNotes = customerRecord.Notes__c;
System.debug('Existing notes:'+existingNotes);
if(existingNotes==null){
customerRecord.Notes__c = customerFeedback;
}
else{
updatedNotes = existingNotes+'\n\n'+customerFeedback;
customerRecord.Notes__c = updatedNotes;
}

System.debug('update notes:'+updatedNotes);
System.debug('Apex'+customerRecord.Notes__c);
update customerRecord;
}
}
*/
    
    //save feedback  Anusurya
    @AuraEnabled
    public static void saveCustomerFeedback(String customerFeedback, String customerName,String bankId){
        system.debug('customerFeedback'+customerFeedback);
        system.debug('customerName'+customerName);
        system.debug('bankId'+bankId);
        
        Bank__c bankRecord=[SELECT Id, Notes__c FROM Bank__c where Id =:bankId];
        
        if (bankRecord!=null) {
            String newCustomerFeedback = 'Submitted on : <b>' + system.today().format()+ '</b> Submitted by : <b>' + customerName + '</b>' + '<br>Comments : <b>' + customerFeedback + '</b>' ;
            system.debug('newCustomerFeedback'+newCustomerFeedback);
            String existingNotes = bankRecord.Notes__c;
            List<String> feedbackList = new List<String>();
            if (!String.isEmpty(existingNotes)) {
                feedbackList = existingNotes.split('<br><br>'); // Split by two line breaks to separate feedback entries
                feedbackList.add(0,newCustomerFeedback);//add the newest feedback at the beginning
            }
            else{
                feedbackList.add(newCustomerFeedback);//add the first feedback
            }
            
            if (feedbackList.size() >= 5) {
                feedbackList.remove(5); // Remove the oldest feedback from the end,ensuring there are no more than 5 
            }
            
            bankRecord.Notes__c = String.join(feedbackList, '<br><br>'); // Join with two line breaks to separate feedback entries
            
            // Update the Bank record
            update bankRecord;
        }
        
    }
    
    
    
    
    
 @AuraEnabled
    public static Id associatedPartyList(String ClaimId, String relationship)
    {
        List<Claim__c> cDetails = [Select Id,Policy__c from Claim__c where Id =: ClaimId limit 1];
        List<Insurance__c> pDetails = [Select Id, Name from Insurance__c where Id =: cDetails[0].Policy__c];
        List<Associated_Parties__c> apDetails =  [SELECT Id, Relationship__c 
                                                  FROM Associated_Parties__c 
                                                  WHERE Relationship__c = :relationship AND Policy__c =: pDetails[0].Id];
        if(!apDetails.isEmpty()) {
            return apDetails[0].Id;
        } 
        else {
            return null; 
        }
    }
    
   
    @AuraEnabled
    
    public static  List<Claim__c> fetchFilteredData(String CustomerId , string numOfClaim , String typeOfClaim, string status){
        system.debug(CustomerId); 
        List<Claim__c> filteredData = new List<Claim__c>();
        Customers__c c= [Select Name from Customers__c where Id =: CustomerId ];
        system.debug(c.Name);
        String CustName = c.Name;
        String query ='Select Id,Name,RecordType.Name, Claim_Type__c,Policy__r.Name ,Status__c,Estimation_Cost__c,Date_Of_Death__c,Date_Of_Accident__c,Date_of_Admission__c,Date_of_Theft__c,Date_Of_Loss__c from Claim__c where Policy_Holder__r.Name =: CustName';
        
        String whereClause = '';
        if(String.isNotBlank(numOfClaim)){
            whereClause = whereClause + ' AND Name =:numOfClaim';
        }
        if(String.isNotBlank(typeOfClaim)){
            if(typeOfClaim =='null'){
                whereClause = whereClause + ' AND Claim_Type__c = null';
            }
            else{
                whereClause = whereClause + ' AND Claim_Type__c =:typeOfClaim';
            }
        }
        if(String.isNotBlank(status)){
            if(status =='null'){
                whereClause = whereClause + ' AND  Status__c = null';
            }
            else{
                whereClause = whereClause + ' AND Status__c =:status';
                system.debug('status'+status);
            }
        }
        query = query +' '+whereClause;
        System.debug('query'+query);
        filteredData = Database.query(query);
        
        System.debug('filterdData '+filteredData);
        return filteredData;
    }
    /*
    @AuraEnabled
    public static List<Claim__c> filterClaimData(String customerId, String claimType, String status, String category){
		System.debug(customerId);
        List<Claim__c> filteredClaimData = new List<Claim__c>();
        Customers__c c= [SELECT Id, Name FROM Customers__c WHERE Id=:customerId];
        String custName = c.Name;
        System.debug(custName);
        String query = 'Select Id, Name, RecordType.Name, Claim_Type__c, Policy__r.Name, Status__c, Estimation_Cost__c, from Claim__c Where Policy_Holder__r.Name =:custName';
        String whereClause = '';
        if(String.isNotBlank(claimType)){
            if(claimType == 'null'){
            	whereClause = whereClause + 'AND Claim_Type__c = null';
            }
            else{
            	whereClause = whereClause + 'AND Claim_Type__c =:claimType';
            }
        }
        if(String.isNotBlank(status)){
            if(status == 'null'){
                whereClause = whereClause + 'AND Status__c = null';
            }
            else{
                whereClause = whereClause + 'AND Status__c =: status';
            }
        }
        if(string.isNotBlank(category)){
            if(category == 'null'){
                whereClause = whereClause + 'AND RecordType.Name = null';
            }
            else{
                whereClause = whereClause + 'AND RecordType.Name =: category';
            }
        }
        query = query +' '+ whereClause;
        System.debug('query'+query);
        filteredClaimData = Database.query(query);
        System.debug('filteredClaimData'+filteredClaimData);
        return filteredClaimData;
    }
    */
    
}