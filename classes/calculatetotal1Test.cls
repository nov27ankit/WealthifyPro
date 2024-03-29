@isTest
public class calculatetotal1Test {
    @isTest
    public static void testCalculatePremium() {
        List<calculatetotal1.MemberInfo> memberList = new List<calculatetotal1.MemberInfo>();
        calculatetotal1.MemberInfo member1 = new calculatetotal1.MemberInfo();
        member1.dob = '1990-01-01';
        member1.salaryVal = 50000.0;
        member1.country= 'India';
        member1.state= 'Maharastra';
        member1.city ='Pune';
        member1.zip =  '4010';
        member1.mobile ='8208686289';
        member1.email = 'hd@cognizant.com';
        member1.address = 'Pune';
        
       
        member1.lifestyleHabits = 'nothing';
        member1.height = 170.0;
        member1.name= 'Hima';
        member1.gender ='Male';
        member1.weight = 70.0;
        memberList.add(member1);

        // Testing premium calculation for one member
        Decimal premium = calculatetotal1.calculatePremium(memberList, 10000.0);
        System.assertEquals(-124130, premium);
       
        calculatetotal1.MemberInfo member2 = new calculatetotal1.MemberInfo();
        member2.dob = '2000-01-01';
        member2.salaryVal = 40.0;
        member2.lifestyleHabits = 'only smoker';
        member2.height = 180.0;
        member2.weight = 80.0;
        memberList.add(member2);
       
        // Testing premium calculation for more than one member
        Decimal premium1 = calculatetotal1.calculatePremium(memberList, 10000.0);
        System.assertEquals(250767, premium1);
       
        calculatetotal1.MemberInfo member3 = new calculatetotal1.MemberInfo();
        member2.dob = '1980-01-01';
        member2.salaryVal = 60.0;
        member2.lifestyleHabits = 'only drinker';
        member2.height = 190.0;
        member2.weight = 90.0;
        memberList.add(member3);
       
        // Testing premium calculation for more than two members
        Decimal premium2 = calculatetotal1.calculatePremium(memberList, 10000.0);
        System.assertEquals(0, premium2);
       
        member2.lifestyleHabits = 'both smoker & drinker';
        // Testing premium calculation for more than one member
        Decimal premium4 = calculatetotal1.calculatePremium(memberList, 10000.0);
        System.assertEquals(0, premium4);
      }
   
      @isTest
      public static void testCalculateQuotePremium() {
            Decimal premium = calculatetotal1.calculatequotepremium(25.0, 10000, 'nothing', 30, 3000);
            System.assertEquals(-6637, premium);
      }
}