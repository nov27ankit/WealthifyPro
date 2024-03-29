public class AppDataController {
    
    @AuraEnabled 
   
    public static DataWrapper retrieveData(String customerId ,ID insureId) {
        
        Map<Id, Insurance__c> mapInsuranceIdVsInsurance = new Map<Id, Insurance__c>();
        Map<Id, List<Claim__c>> mapInsuranceIdVsClaimRecord = new Map<Id, List<Claim__c>>();
        Map<Id, List<Associated_Parties__c>> mapInsuranceIdVsAps = new Map<Id, List<Associated_Parties__c>>();
        Map<Id, Customers__c> mapCustIdVsCustomer = new Map<Id, Customers__c>();
        Map<Id, Bank__c> mapCustIdVsBankRecord = new Map<Id, Bank__c>();
        Map<Id, List<Card__c>> mapCustIdVsCards = new Map<Id, List<Card__c>>();
        Map<Id, List<Payment__c>> mapCustIdVsPayment = new Map<Id, List<Payment__c>>();
        
        AppDataController.DataWrapper wrapper = new AppDataController.DataWrapper();
        
        if(!string.isBlank(customerId)){
            List<Insurance__c> insuranceList = [SELECT 
                                                Id, Name, IsDeleted,RecordType.Name, RecordTypeId, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, 
                                                Customer__c,Customer__r.Name, Insurance_Category__c, 
                                                Company_Provider__c, Sum_Insured__c, Payment_Frequency__c, Is_Auto_Debit__c, Premium_Due_Date__c, 
                                                Debit_Source__c, Plan_Start_Date__c, Status__c, Plan_Term__c, Maturity_Date__c, Payment_Status__c, 
                                                Annual_Premium_Amount__c, Monthly_Premium_Amount__c, Email__c, Type_of_Policy__c, 
                                                Type_of_Package_Policy__c, Registration_Number__c, Registration_Date__c, Registration_Validity__c, 
                                                Year_of_Manufacturing__c, Type__c, Make__c, Specify_the_Make__c, Model__c, Specify_the_Model__c, 
                                                Type_of_Body__c, Colour__c, Specify_The_Color__c, Cubic_Capacity_CC__c, 
                                                Seat_Capacity_Including_Driver__c, Engine_Number__c, Vehicle_Identification_Chassis_Number__c, 
                                                Type_of_Fuel__c, Transmission_Type__c, Under_Pollution_Control__c, Night_Parking__c, 
                                                Fitted_with_Anti_theft_Device__c, Used_for_Driving_Tuition__c, Designed_for_Challenged_People__c, 
                                                Limited_to_Own_Premises__c, Fitted_with_Fiber_Glass_Tank__c, Please_Specify__c, 
                                                Any_Health_Issues__c, Pregnancy__c, Any_Gynaecological_Disorders__c, Expected_Date_of_Delivery__c, 
                                                Abortion_or_Miscarriage_or_C_Section__c, Have_you_ever_been_admitted__c, 
                                                Consult_doctor_in_last_five_years__c, Absent_from_place_of_work__c, 
                                                Liver_Heart_Brain_Kidney_related_illness__c, Suffering_from_Hereditary_Disorders__c, 
                                                Any_Bodily_Defect_or_Deformity__c, Any_Accident_Injury__c, 
                                                Hepatitis_B_or_AIDS_related_condition__c, Drug__c, State_of_Health__c, Insured_House_Number__c, 
                                                Landmark_Locality__c, Insured_House_Name__c, Road_Area_Name__c, City__c, State__c, District__c, 
                                                Pin_Code__c, Age_of_the_Building_In_year__c, Age_of_the_Wiring_In_year__c, 
                                                Age_of_the_Plumbing_In_year__c, Type_of_Building__c, Built_Up_Area_of_the_Dwelling_Sq_Ft__c, 
                                                Adjoining_Area_of_the_Dwelling__c, Garage__c, Occupancy_Type__c, Garage_Type__c, 
                                                Kitchen_Quality__c, Exterior__c, Foundation__c, Roof_Type__c, Interior_Flooring__c, 
                                                Interior_Wall__c, Fitted_with_Five_Lever_Mortice_Deadlock__c, Electronic_Security_Systems__c, 
                                                Fitted_with_Alarms__c, Swimming_Pool__c, Total_Loan_Amount__c, Existing_Loans_on_the_Property__c, 
                                                Outstanding_Interest_Amount__c, Outstanding_Principal_Amount__c, Organisation_Type__c, 
                                                Specify_The_Type_of_Organisation__c, Name_of_Org_Business__c, COVID_19__c, Accident_or_Injury__c, 
                                                Accident_Details__c, Any_type_of_Examination__c, Travel_Overseas__c, Examination_Details__c, 
                                                Armed_Paramilitary_Policeforce_Employee__c, Associate_with_Dangerous_in_any_way__c, 
                                                Weight_lose_in_last_6_months__c, Department_Details__c, Any_Congenital_Defect_Abnormality__c, 
                                                Suffered_Diagnosed_with_or_been__c, No_of_Units__c, Fund_Selected__c, Income_Tax_Assessee__c, 
                                                Registered_under_GST__c, GSTIN__c, KYC_number_Central_KYC_Registry__c, Living_Status__c, 
                                                Are_you_in_sound_health__c, Status_of_the_Building__c, Is_Renewal_Completed__c, 
                                                Last_Premium_Date__c, Co_Payment__c, Status_Reason__c, Policy_Renewal_Date__c, 
                                                Policy_Stage__c, Previous_Policies__c, Maternity_Coverage__c, isEligibleForAdvanced__c, 
                                                Lapsed_Renewal_Date__c, Grace_Period__c, Lapsed_Premium_Due_Date__c, 
                                                Zero_Depriciation_Coverage__c, Anti_Theft_Protection__c, Personal_Accident_Cover__c, 
                                                Portable_Equipment_Cover__c, Natural_Disaster_Coverage__c, Medical_Checkups__c, 
                                                lapsed_declaratioon_signed__c, isEligibleForIntegrated__c, created_Date__c, Policy_Number__c, 
                                                isPolicyLapsed__c, 
                                                (SELECT Id, Name, IsDeleted, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                 Estimation_Cost__c, Claim_Type__c, Claim_Count__c, Additional_Note__c, Date_Of_Accident__c, 
                                                 Status__c, Insured_Person__c,Insured_Person__r.Name,Beneficiary__r.Name, RecordType.Name, Policy__c, Policy__r.Name, Name_of_Hospital__c, Date_of_Admission__c, 
                                                 Date_of_Discharge__c, Cause_of_Admission__c, Is_Accident_Reported_to_Police__c, Hospital__c, 
                                                 Policy_Holder__c,Policy_Holder__r.Name, Place_Of_Death__c, Cause_Of_Death__c, Date_Of_Death__c, 
                                                 Do_You_Have_Death_Certificate__c, Date_Of_Loss__c, Date_Of_Construction__c, 
                                                 Address_Where_the_Loss_can_be_Inspected__c, Reason_for_Loss__c, Kind_Of_Damage__c, 
                                                 Reported_to_Police_about_the_damage__c, Garage_Name__c, Garage_Address__c, Date_of_Theft__c, 
                                                 Date_and_Time_of_Theft__c, Reported_to_Police_about_Theft__c, Room_Category_Occupied__c, 
                                                 Claim_History__c, Claim_Submitted_By__c, Withdrwal__c, Insured_Person_as_per_Bank_Account__c, 
                                                 Bank_Account_Number__c, Branch_Name__c, IFSC_Code__c, Payer_Name__c,  date_on_Cheque__c, 
                                                 Place_of_Theft__c, Reason_For_Claim__c, Is_Sucide__c, Beneficiary__c,Policy__r.Type__c
                                                 FROM Claims__r), 
                                                (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                  Relationship__c, DOB__c, 
                                                 Mobile__c, Email__c, UIN__c, Unique__c, Address__c,State__c,Zip_Code__c,City__c,Country__c,
                                                 Also_a_customer__c, Policy__c, Gender__c, Height_In_Cm__c, Weight_In_Kg__c, Education__c, 
                                                 Marital_Status__c, Occupation__c, Are_you_an_NRI__c, Blood_Group__c, Annual_Income__c, BMI__c, 
                                                 Nature_of_employment__c, Salary__c, Type_Of_ID_Card__c, ID_Card_Number__c, Lifestyle_Habits__c, 
                                                 Total__c, Age__c, salaries__c 
                                                 FROM Associated_Partiess__r) 
                                                FROM Insurance__c where Customer__c=:customerId ];
            system.debug('insuranceList'+insuranceList);
            
            if(insuranceList != null && insuranceList.size()>0){
                for (Insurance__c insurance : insuranceList) {
                    if (!mapInsuranceIdVsInsurance.containsKey(insurance.Id)) {
                        mapInsuranceIdVsInsurance.put(insurance.Id, insurance);
                        mapInsuranceIdVsClaimRecord.put(insurance.Id, insurance.Claims__r);
                        mapInsuranceIdVsAps.put(insurance.Id, insurance.Associated_Partiess__r);
                    }
                }
                system.debug('mapInsuranceIdVsInsurance'+mapInsuranceIdVsInsurance);
                system.debug('mapInsuranceIdVsClaimRecord'+mapInsuranceIdVsClaimRecord);
                system.debug('mapInsuranceIdVsAps'+mapInsuranceIdVsAps);
                
                if (!mapInsuranceIdVsInsurance.isEmpty()) {
                    wrapper.insuranceMap = mapInsuranceIdVsInsurance;
                }
                if (!mapInsuranceIdVsClaimRecord.isEmpty()) {
                    wrapper.claimRecordMap = mapInsuranceIdVsClaimRecord;
                }
                if (!mapInsuranceIdVsAps.isEmpty()) {
                    wrapper.associatedPartiesMap = mapInsuranceIdVsAps;
                }   
            }
            
            List<Customers__c> customerList = [ SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, 
                                               LastModifiedDate, LastModifiedById, 
                                               Bank__c, Customer_Id__c, Street__c, Country__c, Mobile_Phone__c, 
                                               Email__c, Nickname__c, lapsed_declaratioon_signed__c, 
                                               Communication_Preference__c, User_name__c, Password__c, Notes__c, 
                                               manager_mail__c, State__c, City__c, Zip_Code__c, Is_First_Time_User__c, 
                                               Is_Active__c, Last_login__c, Relationship_manager__c, 
                                               PAN__c, Date_of_Birth__c, last_change_date__c, Days_count__c,  
                                               Bank__r.Name,Bank__r.Manager__r.Name,Bank__r.Registration_Number__c, 
                                               Bank__r.Street__c, Bank__r.Zip_Code__c, Bank__r.IFSC_Code__c, 
                                               Bank__r.City__c, Bank__r.State__c, Bank__r.Country__c,
                                               (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById,
                                                Card_Number__c, 
                                                Customer__c, Select_your_Bank__c, Expiry_Date__c, 
                                                Type__c, Total_Card_Limit__c, Available_Card_Limit__c, 
                                                Email_Address__c, Status__c, CVV__c, Card_Network__c, 
                                                Is_This_Primary_Card__c FROM Cards__r Where Status__c='Active'),
                                               (SELECT Id,Amount__c,Card__c,Payment_By__c,Payment_By__r.Name,Payment_Date_Time__c,
                                                Payment_Day__c,Payment_Source__c,Payment_Date__c,Payment_Status__c,Policy__c,Policy__r.Name,Name From Payments__r)
                                               FROM Customers__c where Id=:customerId];
            system.debug('customerList'+customerList);
            
            if(customerList != null && customerList.size()>0){
                for (Customers__c customer : customerList) {
                    if (!mapCustIdVsCustomer.containsKey(customer.Id)) {
                        mapCustIdVsCustomer.put(customer.Id, customer);
                        mapCustIdVsBankRecord.put(customer.Id, customer.Bank__r);
                        mapCustIdVsCards.put(customer.Id, customer.Cards__r);
                        mapCustIdVsPayment.put(customer.Id, customer.Payments__r);
                    }
                }
                system.debug('mapCustIdVsCustomer'+mapCustIdVsCustomer);
                system.debug('mapCustIdVsBankRecord'+mapCustIdVsBankRecord);
                system.debug('mapCustIdVsCards'+mapCustIdVsCards);
                system.debug('mapCustIdVsPayment'+mapCustIdVsPayment);
                
                if (!mapCustIdVsCustomer.isEmpty()) {
                    wrapper.customerMap = mapCustIdVsCustomer;
                    system.debug('mapCustIdVsCustomer'+mapCustIdVsCustomer);
                }
                if (!mapCustIdVsBankRecord.isEmpty()) {
                    wrapper.bankRecordMap = mapCustIdVsBankRecord;
                    system.debug('mapCustIdVsBankRecord'+mapCustIdVsBankRecord);
                }
                if (!mapCustIdVsCards.isEmpty()) {
                    wrapper.cardsMap = mapCustIdVsCards;
                    system.debug('mapCustIdVsCards'+mapCustIdVsCards);
                }
                if (!mapCustIdVsPayment.isEmpty()) {
                    wrapper.paymentMap = mapCustIdVsPayment;
                    system.debug('mapCustIdVsPayment'+mapCustIdVsPayment);
                }
            }       
        }
        system.debug('wrapper'+wrapper);
        return wrapper; 
    }
    
    @AuraEnabled
    public static boolean fetchHealthDetailId(Id HealthDetailId) {
        try {
            Insurance__c insurance = [SELECT Id, Name, Status__c FROM Insurance__c WHERE Id = :HealthDetailId LIMIT 1];
            
            if (insurance != null) {
                insurance.Status__c = 'Inactive';
                update insurance;
                return true;
            } else {
                // Handle the case where the record is not found
                return false;
            }
        } catch (Exception e) {
            // Log the error for debugging purposes
            System.debug('Error: ' + e);
            return false;
        }
    }
    @AuraEnabled
    public static boolean fetchDueDateStatus(Date dueDate){
        Date startDate = Date.today();
        Integer diff=dueDate.daysBetween(startDate);
        if(diff<=15){
            return true;
        }  
        return false;
    }
    @AuraEnabled
    public static List<Insurance__c> fetchFilteredData(Id id, String category, String name, String company, String premium, String sum, String status, String maturityDate){
        // System.debug('company'+company);
        System.debug('name'+name);
        System.debug('premium'+premium);
        List<Insurance__c> filteredData = new List<Insurance__c>();
        String query = 'SELECT Id, Insurance_Category__c, Type__c, Name, Plan_Term__c, Debit_Source__c, Payment_Frequency__c, Company_Provider__c, Annual_Premium_Amount__c, Sum_Insured__c, Maturity_Date__c, Status__c FROM Insurance__c WHERE Customer__c = :id AND Type__c = \'Internal\'';
        String whereClause = '';
        if(String.isNotBlank(category)){
            whereClause = whereClause + ' AND Insurance_Category__c =:category';
        }
        
        if(String.isNotBlank(name)){
            whereClause = whereClause + ' AND Name =:name';
        }
        
        if(String.isNotBlank(company)){
            System.debug('in company block');
            if(company=='null'){
                whereClause = whereClause + ' AND Company_Provider__c =null'; 
            }else{
                whereClause = whereClause + ' AND Company_Provider__c =:company';
            }
            
        }
        
        if(String.isNotEmpty(premium)){
            if(premium =='null'){
                whereClause = whereClause + ' AND Annual_Premium_Amount__c =null';
            }else{
                Integer premiumAmount = Integer.ValueOf(premium);
                whereClause = whereClause + ' AND Annual_Premium_Amount__c <=:premiumAmount';
            }
        }
        
        if(String.isNotEmpty(sum)){
            if(sum =='null'){
                whereClause = whereClause + ' AND Sum_Insured__c =null';
            }else{
                Integer sumAmount = Integer.ValueOf(sum);
                whereClause = whereClause + ' AND Sum_Insured__c <=:sumAmount';
            }
        }
        
        if(String.isNotBlank(status)){
            System.debug(status);
            whereClause =whereClause + ' AND Status__c =:status';
        }
        
        if(String.isNotBlank(maturityDate)){
            Date dateOfMaturity = Date.valueOf(maturityDate);
            whereClause = whereClause + ' AND Maturity_Date__c <=:dateOfMaturity';
        }
        
        query = query +' '+whereClause;
        System.debug('query'+query);
        filteredData = Database.query(query);
        System.debug('filterdData '+filteredData);
        return filteredData;
        
    }
    
    public class DataWrapper {
        @AuraEnabled public Map<Id, Insurance__c> insuranceMap { get; set; }
        @AuraEnabled public Map<Id, List<Claim__c>> claimRecordMap { get; set; }
        @AuraEnabled public Map<Id, List<Associated_Parties__c>> associatedPartiesMap { get; set; }
        @AuraEnabled public Map<Id, Customers__c> customerMap { get; set; }
        @AuraEnabled public Map<Id, Bank__c> bankRecordMap { get; set; }
        @AuraEnabled public Map<Id, List<Card__c>> cardsMap { get; set; }
        @AuraEnabled public Map<Id, List<Payment__c>> paymentMap { get; set; }
    }
}