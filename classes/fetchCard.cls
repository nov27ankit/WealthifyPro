public class fetchCard {

    @AuraEnabled
    public static list<Card__c> cCard(string id){
        System.debug('hello');
        list<Card__c> allCard = new list<Card__c>();
        allCard = [SELECT Id, Available_Card_Limit__c, Name, Card_Number__c,  Customer__c,CVV__c,Email_Address__c,Select_your_Bank__r.Name,Status__c,Total_Card_Limit__c,Type__c,Expiry_Date__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: id AND Status__c='Active' AND Is_This_Primary_Card__c=True];
        return allCard;
    }

    @AuraEnabled
    public static list<Card__c> creditCard(string id){
        System.debug('hello');
        list<Card__c> allCard = new list<Card__c>();
        allCard = [SELECT Id, Available_Card_Limit__c, Name, Card_Number__c,  Customer__c,CVV__c,Email_Address__c,Select_your_Bank__r.Name,Status__c,Total_Card_Limit__c,Type__c,Expiry_Date__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: id AND Status__c='Active'];
        return allCard;
    }
    
    
    @AuraEnabled
    public static list<Card__c> filter(string id, string type,string cardHolderName,string bank,string network,string expiryDate){
        System.debug('hello123');
        list<Card__c> allCard = new list<Card__c>();
        string active='Active';
        string Query = 'SELECT Id, Available_Card_Limit__c, Name, Card_Number__c,Customer__c,CVV__c,Email_Address__c,Select_your_Bank__r.Name,Status__c,Total_Card_Limit__c,Type__c,Card_Network__c,Expiry_Date__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.Id=: id AND Status__c=:active';
        string whereClause = '';
        system.debug('****type'+type);
        if(string.isNotEmpty(type)){
            if(type=='None'){
                whereClause = whereClause;
            }
            else{
                whereClause = whereClause+' AND Type__c=:type';
            }
            
            
        }
        system.debug('****CardHolderName'+cardHolderName);
        if(string.isNotEmpty(cardHolderName)){
            string wk='%'+cardHolderName+'%';
            whereClause = whereClause+' AND Name LIKE : wk';
            
        }
        system.debug('****bank'+bank);
        if(string.isNotEmpty(bank)){
            string lk='%'+bank+'%';
            whereClause  = whereClause+' AND Select_your_Bank__r.Name LIKE : lk';   
        }
        system.debug('****network'+network);
        if(string.isNotEmpty(network)){
            if(network=='None'){
                whereClause = whereClause;
            }
            else if(network=='null'){
                whereClause = whereClause+' AND Card_Network__c= null';
            }
            else{
                whereClause  = whereClause+' AND Card_Network__c=:network';   
            }
        }
        system.debug('****expiryDate'+expiryDate);
        if(string.isNotBlank(expiryDate)){
            Date x = Date.valueOf(expiryDate);
            whereClause  = whereClause+' AND Expiry_Date__c<=:x';   
        }
        
       
        Query = Query +' '+whereClause;
        system.debug('carQuery'+Query);
        allCard = Database.query(Query);
        system.debug('allCard'+allCard);
        return allCard;
    }

    @AuraEnabled
    public static void primaryCard(string id){
        Card__c card=[SELECT Id, Available_Card_Limit__c, Name, Card_Number__c,  Customer__c,CVV__c,Email_Address__c,Select_your_Bank__r.Name,Status__c,Total_Card_Limit__c,Type__c,Expiry_Date__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE ID=: id];
        card.Is_This_Primary_Card__c= true;
        update card;
    }

    @AuraEnabled(cacheable=true)
    public static Wrapper getAccounts(string id) {
        //List<Card__c> all=new List<Card__c>();
        List<Card__c> temp=[SELECT Id, Name,Card_Number__c,Select_your_Bank__r.Name, Type__c,Expiry_Date__c,CVV__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: id AND Status__c='Active'];
        List<Card__c> all=[SELECT Id, Name,Card_Number__c,Select_your_Bank__r.Name, Type__c,Expiry_Date__c,CVV__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: id AND Status__c='Active'];
        for(Card__c card:temp){
            card.Card_Number__c=card.Select_your_Bank__r.Name;
            //all.add(card);
        }

        Wrapper data=new Wrapper();
        data.res1=temp;
        data.res2=all;
        return data;
        //return [SELECT Id, Name,Select_your_Bank__r.Name, Card_Number__c,Type__c,Expiry_Date__c,Card_Network__c,Is_This_Primary_Card__c FROM Card__c WHERE Customer__r.id=: id AND Status__c='Active'];
    }

    @AuraEnabled
    public static Insurance__c policy(string id) {
        return [Select Id,Name , Status__c ,Insurance_Category__c,Plan_Term__c , Company_Provider__c , Sum_Insured__c , Plan_Start_Date__c , Maturity_Date__c , Annual_Premium_Amount__c,
            Payment_Frequency__c , Is_Auto_Debit__c , //Insurer_s_Gender__c , Blood_Group__c , Height_In_Cm__c , Weight_In_Kg__c, 
            Any_Health_Issues__c ,Insured_House_Number__c , State__c , Age_of_the_Building_In_year__c , Type_of_Building__c , Existing_Loans_on_the_Property__c,
                // Marital_Status__c,
                Organisation_Type__c,Monthly_Premium_Amount__c,Premium_Due_Date__c,Lapsed_Premium_Due_Date__c,Policy_Renewal_Date__c,
                Registration_Number__c,Registration_Date__c,Year_of_Manufacturing__c,Type_of_Fuel__c,Model__c,
                   //Occupation__c,
                   Drug__c
                    from Insurance__c 
                     where Id =:id];
    }

    public class Wrapper{
        @AuraEnabled
        public List<Card__c> res1{get;set;}
        @AuraEnabled
        public List<Card__c> res2{get;set;}
    }
    
    


    @AuraEnabled
     public static Payment__c pay(string id,Integer amt,string cid,string pid,Insurance__c policy, Integer amount){
        system.debug('hello');
        system.debug(policy);
        system.debug(amount);
        Datetime d = System.now();
        Integer month= policy.Plan_Term__c.intValue();
        //Datetime dt = (DateTime)d;
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        Payment__c payed=new Payment__c();
        if(amount!=0){
            if(policy.Payment_Frequency__c=='Monthly')
            {
                //payed.Amount__c=Math.round(amt/12);
                payed.Amount__c=amt/12.0;
                policy.Policy_Renewal_Date__c=policy.Policy_Renewal_Date__c.addMonths(month);
            }
            else{
                payed.Amount__c=amt;
                policy.Policy_Renewal_Date__c=policy.Policy_Renewal_Date__c.addMonths(month);
            }
            System.debug(policy.Plan_Term__c);
            payed.Payment_Source__c='Policy renewal';
            policy.Is_Renewal_Completed__c=true;
            
        }
        else{
            if(policy.Payment_Frequency__c=='Monthly')
            {
                //payed.Amount__c=Math.round(amt/12);
                payed.Amount__c=amt/12.0;
                policy.Premium_Due_Date__c=policy.Premium_Due_Date__c.addMonths(1);
            }
            else{
                payed.Amount__c=amt;
                policy.Premium_Due_Date__c=policy.Premium_Due_Date__c.addYears(1);
            }
            payed.Payment_Source__c='Premium payment';
        }
        
        payed.Card__c=cid;
        payed.Payment_Date_Time__c=d;
        payed.Name=hexDigest.substring(4,16);
        payed.Payment_Day__c=d.format('EEEE');
        payed.Payment_By__c=id;
    //  payed.Payment_Source__c=;
        payed.Payment_Status__c='Completed';
        payed.Policy__c=pid;
        insert payed;
        policy.Status__c='Active';
        policy.Annual_Premium_Amount__c=amt;
        policy.Last_Premium_Date__c=Date.today();
        policy.Payment_Status__c='Paid';
        update policy;
        return payed;
     }


   
     
     @AuraEnabled
    public static list<Payment__c> filterpay(string id, string name,string paydate, String status){
        System.debug('hello123');
        list<Payment__c> allCard = new list<Payment__c>();
        string Query = 'SELECT Id,Amount__c,Card__c,Payment_By__c,Payment_By__r.Name,Payment_Date_Time__c, Payment_Day__c,Payment_Source__c,Payment_Date__c,Payment_Status__c,Policy__c,Policy__r.Name,Name From Payment__c Where Payment_By__c=: id';
        string whereClause = '';

        system.debug('****name'+name);
        if(string.isNotEmpty(name)){
            string wk='%'+name+'%';
            whereClause = whereClause+' AND Policy__r.Name LIKE : wk';
            
        }
        
        
        system.debug('****Date'+paydate);
        if(string.isNotBlank(paydate)){
            Date x = Date.valueOf(paydate);
            whereClause  = whereClause+' AND Payment_Date__c =:x';   
        }
        // here
        system.debug('****status'+status);
        if(string.isNotEmpty(status)){
            if(status=='None'){
                whereClause = whereClause;
            }
            // else if(network=='null'){
            //     whereClause = whereClause+' AND Card_Network__c= null';
            // }
            else{
                whereClause  = whereClause+' AND Payment_Status__c=:status';   
            }
        }
        
       
        Query = Query +' '+whereClause;
        system.debug('carQuery'+Query);
        allCard = Database.query(Query);
        system.debug('allCard'+allCard);
        return allCard;
    }
    
    //Claim Summary
    @AuraEnabled
    public static List<Claim__c> filterClaim(string id, string status){
        List<Claim__c> allClaims = new List<Claim__c>();
        string query = '';
        return allClaims;
        
		        
    }
    
}