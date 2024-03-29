public class MemberController {
    public class AddMemberWrapper {
    @AuraEnabled
    public String name{get;set;}
    @AuraEnabled
    public String relation{get;set;}
    @AuraEnabled
    public Id policy{get;set;}
    @AuraEnabled
    public String gender{get;set;}
    @AuraEnabled
    public String dob{get;set;}
    @AuraEnabled
    public String education{get;set;}
    @AuraEnabled
    public String maritalStatus{get;set;}
    @AuraEnabled
    public String typeOfId{get;set;}
    @AuraEnabled
    public String idNumber{get;set;}
    @AuraEnabled
    public String occupation{get;set;}
    @AuraEnabled
    public String employment{get;set;}
    @AuraEnabled
    public String salary{get;set;}
    @AuraEnabled
    public Integer height{get;set;}
    @AuraEnabled
    public Double weight{get;set;}
    @AuraEnabled
    public String bloodGroup{get;set;}
    @AuraEnabled
    public Double bmi{get;set;}
    @AuraEnabled
    public String lifestyleHabits{get;set;}
    @AuraEnabled
    public String email{get;set;}
    @AuraEnabled
    public String mobile{get;set;}
    @AuraEnabled
    public String address{get;set;}
    @AuraEnabled
    public String city{get;set;}
    @AuraEnabled
    public String state{get;set;}
    @AuraEnabled
    public String country{get;set;}
    @AuraEnabled
    public String zip{get;set;}
    @AuraEnabled
    public Double salaryVal{get;set;}

    }

    @AuraEnabled
    public static String createNewMembers(List<AddMemberWrapper> wrapper, Id policy,String frequency,Boolean isAutoDebit, String debitSource){
        System.debug('wrapper : '+wrapper);
        if(!wrapper.isEmpty()){
            List<Associated_Parties__c> newAP = new List<Associated_Parties__c>();
            for(AddMemberWrapper item : wrapper){
                Date dob= Date.valueOf(item.dob);
            Associated_Parties__c ap = new Associated_Parties__c(Name=item.name,Relationship__c=item.relation,Policy__c=item.policy,Gender__c=item.gender,DOB__c=dob,Education__c=item.education,Marital_Status__c=item.maritalStatus,Type_Of_ID_Card__c=item.typeOfId,ID_Card_Number__c=item.idNumber,Occupation__c=item.occupation,Nature_of_employment__c=item.employment,Salary__c=item.salary,salaries__c=item.salaryVal,Height_In_Cm__c=item.height,Weight_In_Kg__c=item.weight,Blood_Group__c=item.bloodGroup,Lifestyle_Habits__c=item.lifestyleHabits,Email__c=item.email,Mobile__c=item.mobile,Address__c=item.address,City__c=item.city,State__c=item.state,Country__c=item.country,Zip_Code__c=item.zip);
            newAP.add(ap);
        	}
         System.debug('newList'+newAP);
        insert newAP;
        System.debug('member created from apex');
        }
        Insurance__c insurance = [Select Id, Name ,Payment_Frequency__c,Debit_Source__c,Is_Auto_Debit__c from Insurance__c where Id=:policy];
        insurance.Payment_Frequency__c=frequency;
        insurance.Debit_Source__c=debitSource;
        insurance.Is_Auto_Debit__c=isAutoDebit;

        update insurance;
        System.debug('payment data updated from apex');
        return 'Member added and payment details updated from apex';
    }

    @AuraEnabled
    public static void healthAddOns(Id policy,Boolean maternityCoverage, Boolean medicalCheckup, Boolean coPay){
        Insurance__c insurance = [Select Id, Name from Insurance__c where Id=:policy];
        System.debug('in health Addons'+maternityCoverage+medicalCheckup+coPay);
            insurance.Maternity_Coverage__c= maternityCoverage;
           insurance.Medical_Checkups__c = medicalCheckup; 
           insurance.Co_Payment__c = coPay; 
        update insurance;
    }
    
    @AuraEnabled
    public static void vehicleAddOns(Id policy,Boolean antiTheft, Boolean zeroDepth, Boolean disasterCover,Boolean accidentCover){
        Insurance__c insurance = [Select Id, Name from Insurance__c where Id=:policy];
        if(antiTheft !=Null){
	        insurance.Anti_Theft_Protection__c= antiTheft;      
        }
        if(zeroDepth !=Null){
           insurance.Zero_Depriciation_Coverage__c= zeroDepth; 
        }
        if(disasterCover !=Null){
           insurance.Natural_Disaster_Coverage__c = disasterCover; 
        }
    	if(accidentCover !=Null){
           insurance.Personal_Accident_Cover__c = accidentCover; 
        }
        update insurance;
    }
    
    @AuraEnabled
    public static void homeAddOns(Id policy,Boolean antiTheft, Boolean coPay, Boolean disasterCover,Boolean equipmentCover){
        Insurance__c insurance = [Select Id, Name from Insurance__c where Id=:policy];
        if(antiTheft !=Null){
	        insurance.Anti_Theft_Protection__c= antiTheft;      
        }
        if(coPay !=Null){
           insurance.Co_Payment__c= coPay; 
        }
        if(disasterCover !=Null){
           insurance.Natural_Disaster_Coverage__c = disasterCover; 
        }
    	if(equipmentCover !=Null){
           insurance.Portable_Equipment_Cover__c = equipmentCover; 
        }
        update insurance;
    }
    
    @AuraEnabled
    public static void lifeAddOns(Id policy,Boolean maternityCoverage, Boolean medicalCheckup){
        Insurance__c insurance = [Select Id, Name from Insurance__c where Id=:policy];
        if(maternityCoverage !=Null){
            insurance.Maternity_Coverage__c= maternityCoverage;
        }
        if(medicalCheckup !=Null){
           insurance.Medical_Checkups__c = medicalCheckup; 
        }
        update insurance;
    }
    
         

    // meena,madhurima can work from here

     @AuraEnabled
     public static Payment__c payment(string id,Integer amt,string cid,string pname,Decimal sum, String cat, Integer term, String fre,List<AddMemberWrapper> wrapper){
        Insurance__c policy=new Insurance__c();
        System.debug(cat);
        policy.Name=pname+''+String.valueOf(Datetime.now().formatGMT('yyyyMMddHHmmss'));
        policy.Customer__c=id;
        policy.Annual_Premium_Amount__c=amt;
        //policy.Insurance_Category__c='ULIP';
        policy.Insurance_Category__c=cat;
        policy.Company_Provider__c='Default';
        policy.Sum_Insured__c= sum;
        if ( cat=='Home'){
            policy.RecordTypeId='0125j000000SU16AAG';
            
        }
        else if ( cat=='Health'){
            policy.RecordTypeId='0125j000000SU15AAG';
                                 
        }
        else if ( cat=='Life'){
            policy.RecordTypeId='0125j000000SU17AAG';
        }
        else if ( cat=='Term'){
            policy.RecordTypeId='0125j000000SU18AAG';
        }
            else if ( cat=='ULIP'){
            policy.RecordTypeId='0125j000000SU19AAG';
        }
            else if ( cat=='Vehicular'){
            policy.RecordTypeId='0125j000000SU1AAAW';
        }
        policy.Status__c='Active';
        policy.Type__c = 'Internal';
        System.debug(Date.today());
        policy.Plan_Start_Date__c=Date.today();
        policy.Last_Premium_Date__c=Date.today();
        policy.Policy_Stage__c='Basic';
        policy.Plan_Term__c=term;
        policy.Premium_Due_Date__c=Date.today();
        policy.Policy_Renewal_Date__c=policy.Plan_Start_Date__c.addMonths(term);
        policy.Payment_Frequency__c=fre;
        System.debug(policy);
        insert policy;

        // payment object from here

        Datetime d = System.now();
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        System.debug(String.valueOf(Datetime.now().formatGMT('yyyyMMddHHmmss')));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        Payment__c payed=new Payment__c();
// ''
        payed.Card__c=cid;
        //payed.Amount__c=amt;
        payed.Payment_Date_Time__c=d;
        payed.Name=hexDigest.substring(4,16);
        payed.Payment_Day__c=d.format('EEEE');
        payed.Payment_By__c=id;
        payed.Policy__c=policy.Id;
        payed.Payment_Status__c='Completed';
        payed.Payment_Source__c='Policy buy out';
        if(fre=='Monthly')
            {
                //payed.Amount__c=Math.round(amt/12);
                payed.Amount__c=amt/12.0;
                policy.Premium_Due_Date__c=policy.Premium_Due_Date__c.addMonths(1);
            }
            else{
                payed.Amount__c=amt;
                policy.Premium_Due_Date__c=policy.Premium_Due_Date__c.addYears(1);
            }
        insert payed;
        System.debug(payed);

        policy.Payment_Status__c='Paid';
        update policy;
// ap insert
        System.debug('wrapper : '+wrapper);
        if(!wrapper.isEmpty()){
            List<Associated_Parties__c> newAP = new List<Associated_Parties__c>();
            for(AddMemberWrapper item : wrapper){
                Date dob= Date.valueOf(item.dob);
            Associated_Parties__c ap = new Associated_Parties__c(Name=item.name,Relationship__c=item.relation,Policy__c= policy.ID,Gender__c=item.gender,DOB__c=dob,Education__c=item.education,Marital_Status__c=item.maritalStatus,Type_Of_ID_Card__c=item.typeOfId,ID_Card_Number__c=item.idNumber,Occupation__c=item.occupation,Nature_of_employment__c=item.employment,Salary__c=item.salary,salaries__c=item.salaryVal,Height_In_Cm__c=item.height,Weight_In_Kg__c=item.weight,Blood_Group__c=item.bloodGroup,Lifestyle_Habits__c=item.lifestyleHabits,Email__c=item.email,Mobile__c=item.mobile,Address__c=item.address,City__c=item.city,State__c=item.state,Country__c=item.country,Zip_Code__c=item.zip);
            newAP.add(ap);
        	}
         System.debug('newList'+newAP);
        insert newAP;
        System.debug('member created from apex');
        }

        return payed;
     }
}