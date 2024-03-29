Public Class policyUpgradeController{
    //
    @AuraEnabled(cacheable=true)    
    public static List<Insurance__c>basicToAdvanced( Id policyId){
        system.debug('inside basic to advanced ' );
        List<Insurance__c>  policiesToUpdateForAdvance   = [select id,Name ,Plan_Start_Date__c,Policy_Renewal_Date__c,Lapsed_Renewal_Date__c,
                                                            Premium_Due_Date__c,Lapsed_Premium_Due_Date__c,//Age_years_months__c,
                                                            Sum_Insured__c,
                                                            Status__c,Policy_Stage__c,isEligibleForAdvanced__c,isEligibleForIntegrated__c,isPolicyLapsed__c from Insurance__c
                                                            where Id=:policyId
                                                            And Status__c = 'Active'                                                           
                                                            And Sum_Insured__c>=200000
                                                            And Plan_Start_Date__c <= Last_N_Days:730
                                                            And isPolicyLapsed__c = false]; //And Id=:policyId 
        
        system.debug(policiesToUpdateForAdvance+'policiesforadgfabsfdvxjt');
        return policiesToUpdateForAdvance;
    }
    
    @AuraEnabled(cacheable=true)    
    public static    List<Insurance__c> advancedTointegrated(Id policyId){
        system.debug('inside adv to int  ');
        // List<Insurance__c> filteredInsLst = new List<Insurance__c>();        
        List<Insurance__c> policiesToUpdateForIntegrated =[select id,Name ,Plan_Start_Date__c,Policy_Renewal_Date__c,Lapsed_Renewal_Date__c,
                                                           Premium_Due_Date__c,Lapsed_Premium_Due_Date__c,//Age_years_months__c,
                                                           Sum_Insured__c,
                                                           Status__c,Policy_Stage__c,isEligibleForAdvanced__c,isEligibleForIntegrated__c,isPolicyLapsed__c from Insurance__c
                                                           where Id=:policyId
                                                           And  Status__c = 'Active'
                                                           And Policy_Stage__c='Advanced'
                                                           And Sum_Insured__c>=400000
                                                           And Plan_Start_Date__c <= Last_N_Days:730
                                                          And isPolicyLapsed__c = false];//And Id=:policyId  a025i00000U23PZAAZ
        
        system.debug(policiesToUpdateForIntegrated+'policiesforint');
        return policiesToUpdateForIntegrated;
    }
    @AuraEnabled(cacheable=true)  
    public static Object ageCalculator(Id policyId  ){
        system.debug('inside age calculator ');
        List<Customers__c> lstsort =   [select Name, Date_of_Birth__c , 
                                        (select Name from Insurances__r where Id =: policyId)from Customers__c where id IN 
                                        (select Customer__c from Insurance__c where Id =: policyId)];
        
        Date curentDate = Date.today();
        //query to filter insurances based on the criteria of age 
        Decimal fnlValue;
        Decimal age;
        for(Customers__c Dob:lstsort){
            if(Dob.Date_of_Birth__c != null){
                Date birthDate =  Dob.Date_of_Birth__c;
                Integer birthYear = Dob.Date_of_Birth__c.year(); system.debug('birthyear' + birthYear);
                Integer currentYear = curentDate.year(); system.debug('currentyear'+currentYear);
                age = currentYear - birthYear; system.debug('age'+age);
                Decimal targetValue = age;
                
                //query the custom setting record
              PolicyUpgrade__c custsettingrecord = PolicyUpgrade__c.getInstance();
                system.debug('custrecords'+custsettingrecord);
                if(custsettingrecord != null && !String.isEmpty(custsettingrecord.Range_Settings__c)){
                    System.debug('101');
                    //parse json 
                    System.debug('let check '+custsettingrecord.Range_Settings__c);
                    Map<String,Object> jsonMap = (Map<String,Object>)JSON.deserializeUntyped(custsettingrecord.Range_Settings__c);
       
                    //Access the ranges array 
                    List<Object> ranges = ( List<Object>)jsonMap.get('rng');
                    system.debug('ranes i  list '+ranges);
                    // check if the target value is in multiples of 5 
                    Boolean isMultipleOf5 = false ;
                    // Initialize a boolean to track if the target age is within the range
                    Boolean isWithInRange = false;
                    Decimal nextMultipleof5 = null;
                    for(Object ietarteList: ranges){ 
                        Map<String,Object> rg = ( Map<String,Object>) ietarteList;
                        system.debug('ranes i  list '+rg);
                        Decimal lowerBound = (Decimal)rg.get('lB');
                        Decimal UperBound = (Decimal)rg.get('UB');                        
                        system.debug('lowebound '+ lowerBound + 'uppwr bound '+ UperBound );
                        if(targetValue >lowerBound && targetValue <=UperBound ){
                            fnlValue=UperBound;
                            String rangeName = (String)rg.get('nm');
                            
                            // check if the target value is not within range and is not multiple of 5                            
                            system.debug('value'+ targetValue +'falls within'+ rangeName + 'name is' +
                                         lowerBound + ' ..... ' +  UperBound+ '     ' +fnlValue );
                            system.debug(fnlValue +'upperBoundValue updated');
                            break;
                        }
                        else{
                            fnlValue =lowerBound;
                            String rangeName1 = (String)rg.get('nm');
                            system.debug('value'+ targetValue +'falls within'+ rangeName1 + 'name is' + 
                                         lowerBound + ' ..... ' +  UperBound+ '     ' +fnlValue );
                            break;
                            
                        }
                    }
                }
            }
        }

        Map<String, Decimal> myResult = new Map<String, Decimal> ();
        myResult.put('one',age);	
        myresult.put('two',fnlValue);
        system.debug(myResult + 'result');
        
        return (myResult);
    }
    @AuraEnabled
    public static void checkForIsEligible(Id policyId,Boolean isEligibleforAdvance,Boolean isEligibleforIntegrated ){
        Insurance__c insurance = [Select Id, Name,isEligibleForAdvanced__c,isEligibleForIntegrated__c from Insurance__c where Id=:policyId];
        if(isEligibleforAdvance !=Null && isEligibleforAdvance == true  ){
            insurance.isEligibleForAdvanced__c= isEligibleforAdvance;
            system.debug(isEligibleforAdvance +'is eligible for advance');         
        }
        if(isEligibleforIntegrated !=Null && isEligibleforIntegrated ==true && isEligibleforAdvance == false ){
            insurance.isEligibleForIntegrated__c = isEligibleforIntegrated;
            insurance.isEligibleForAdvanced__c = isEligibleforAdvance;
            system.debug(isEligibleforIntegrated + 'is eligible for integrated ');  
        }            update insurance;
    }       
}