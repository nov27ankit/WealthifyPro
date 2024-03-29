public class calculatetotal1 {
   @AuraEnabled

   public Decimal AgeFactor;
   public Decimal BmiFactor;
   public Decimal LifeFactor;
   public Decimal SalaryFactor;
    
    public class MemberInfo {
        
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
    public Double height{get;set;}
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

   public static Decimal calculatePremium(List<MemberInfo> newMemberList, Decimal sumInsured1) {
       System.debug(newMemberList);
       System.debug(sumInsured1);
       Decimal largestPremium = 0;
       Decimal smallestPremium = 999999999;
       Decimal totalPremium = 0;
       integer numMembers= newMemberList.size();
       system.debug('num'+numMembers);
       

       for (MemberInfo member : newMemberList) {
             if (member.dob == null || member.salaryVal == null || member.lifestyleHabits == null ||
            member.height == null || member.weight == null || sumInsured1 == null) {
                return 0;
        }
           
           Double BMI = (member.weight / ((member.height / 100) * (member.height / 100)));

		   System.debug(BMI);
           Integer Age;
           Date today = Date.today();
           System.debug('today'+today);
           Date startDate = Date.valueOf(member.dob);
           System.debug('startdate'+startDate);
           Integer DaysDifference = startDate.daysBetween(today);
           Age = DaysDifference / 365;
           System.debug('Age: '+Age);

           Decimal AgeFactor = calculateAgeFactor(Age);
           system.debug('AgeFactor: '+AgeFactor);
           Decimal  BmiFactor = calculateBmiFactor(BMI);
           system.debug('BmiFactor: '+BmiFactor);

           Decimal LifeFactor = calculateLifeFactor(member.lifestyleHabits);
           system.debug('LifeFactor: '+LifeFactor);

           Decimal SalaryFactor = calculateSalaryFactor(member.salaryVal);
           system.debug('SalaryFactor: '+SalaryFactor);

           Decimal total = (AgeFactor + BmiFactor + LifeFactor + SalaryFactor) + 100;
           system.debug('total: '+ total);


           Decimal sumInsured = sumInsured1;

           Decimal premium = (sumInsured * total) / 100;

           // Update the largest and smallest premiums
           if (premium > largestPremium) {
               largestPremium = premium;
               
           }
           if (premium < smallestPremium ) {
               smallestPremium = premium;
               
           }

           totalPremium += premium;
       }

       // Premium calculation if there is more than one member
       if(numMembers > 1){
           return adjustPremium(largestPremium, smallestPremium, numMembers);
       }
       Integer intPremium = (totalPremium.intValue())/12;
       System.debug('premium'+intPremium);
       return intPremium;
   }


   public static Decimal adjustPremium(Decimal largestPremium, Decimal smallestPremium, Integer numMembers) {
       Decimal difference = (largestPremium - smallestPremium) * numMembers;
       largestPremium += difference;
       Integer finalpermium=(largestPremium.intValue())/12;
       return finalpermium;
   }
   @AuraEnabled
    public static Decimal calculatequotepremium(Decimal BMI, Integer sumInsured1,string Lifestyle,integer Age,double Salary) {
           Decimal AgeFactor = calculateAgeFactor(Age);
           system.debug('AgeFactor: '+AgeFactor);
           Decimal  BmiFactor = calculateBmiFactor(BMI);
           system.debug('BmiFactor: '+BmiFactor);

           Decimal LifeFactor = calculateLifeFactor(Lifestyle);
           system.debug('LifeFactor: '+LifeFactor);

           Decimal SalaryFactor = calculateSalaryFactor1(salary);
           system.debug('SalaryFactor: '+SalaryFactor);

           Decimal total = (AgeFactor + BmiFactor + LifeFactor + SalaryFactor) + 100;
           system.debug('total: '+ total);


           //Decimal sumInsured = sumInsured1;

           Decimal premium1 = (sumInsured1 * total) / 100;
         Integer intPremium1 = (premium1.intValue())/12;
       System.debug('premium'+intPremium1);
       return intPremium1;
    }
        
    
     public Static Decimal calculateAgeFactor(Integer Age) {
        return (Age - 42.5) * 0.35;
    }

    public Static Decimal calculateBmiFactor(Decimal BMI) {
        return ((BMI - 27.7) * 2) * 0.20;
    }

    public static Decimal calculateLifeFactor(String lifestyle) {
        Decimal Life = 0;
        if (lifestyle != null) {
            if (lifestyle.equals('nothing')) {
                Life = 0;
            } else if (lifestyle.equals(lifestyle.equals('No Drink, No Smoke'))){
                Life = 0;
            }
            else if (lifestyle.equals('only smoker')) {
                Life = 75;
            } else if (lifestyle.equals('only drinker')) {
                Life = 75;
            } else if (lifestyle.equals('both smoker & drinker')) {
                Life = 100;
            }
        }
        return Life * 0.15;
    }

    public static Decimal calculateSalaryFactor(Double Salary) {
        return (30.0 - Salary) * 0.30;
    }

      public static Decimal calculateSalaryFactor1(double Salary) {
        System.debug(Salary);
        
        return (30.0 - Salary) * 0.30;
        
    }
    
   
}