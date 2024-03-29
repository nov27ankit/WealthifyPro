@isTest
public class PrimarycardTriggerHandlerTest {

    @isTest
    static void testInsertPrimaryCard() {
        // Test inserting primary cards
        Bank__c bank = new Bank__c(Name = 'ICICU');
        insert bank;

        Customers__c customer = createTestCustomer(bank.Id);
        insert customer;

        List<Card__c> testCards = createTestCards(customer.Id, true, bank.Id);
        insert testCards;

        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :testCards];
        for (Card__c card : updatedCards) {
            System.assertEquals(true, card.Is_This_Primary_Card__c, 'Primary card should be set to true');
        }
    }

    @isTest
    static void testInsertNonPrimaryCard() {
        // Test inserting non-primary cards
        Bank__c bank = new Bank__c(Name = 'ICICU');
        insert bank;

        Customers__c customer = createTestCustomer(bank.Id);
        insert customer;

        // Insert a primary card first
        List<Card__c> primaryCards = createTestCards(customer.Id, true,bank.Id);
        insert primaryCards;

        // Insert additional non-primary cards
        List<Card__c> nonPrimaryCards = createTestCards(customer.Id, false,bank.Id);
        insert nonPrimaryCards;

        List<Card__c> allCards = new List<Card__c>();
        allCards.addAll(primaryCards);
        allCards.addAll(nonPrimaryCards);

        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :allCards];
        for (Card__c card : updatedCards) {
            if (nonPrimaryCards.contains(card)) {
                System.assertEquals(false, card.Is_This_Primary_Card__c, 'Non-primary cards should have Is_This_Primary_Card__c set to false');
            } 
            if(primaryCards.contains(card)) {
                System.assertEquals(true, card.Is_This_Primary_Card__c, 'Primary card should be set to true');
            }
        }
    }
    
    @isTest
    static void testUpdatePrimaryCard() {
        // Test updating primary cards to non-primary
        Bank__c bank = new Bank__c(Name = 'ICICU');
        insert bank;

        Customers__c customer = createTestCustomer(bank.Id);
        insert customer;

        // Insert primary cards first
        List<Card__c> primaryCards = createTestCards(customer.Id, true,bank.Id);
        insert primaryCards;

        // Update the primary cards to non-primary
        for (Card__c card : primaryCards) {
            card.Is_This_Primary_Card__c = false;
        }
        update primaryCards;

        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :primaryCards];
        for (Card__c card : updatedCards) {
            System.assertEquals(false, card.Is_This_Primary_Card__c, 'Primary cards should be updated to non-primary');
        }
        
        
    }
    @isTest
    static void testInsertAndUpdateMix() {
        // Test a mix of inserting primary and non-primary cards and then updating some of them
        Bank__c bank = new Bank__c(Name = 'ICICU');
        insert bank;

        Customers__c customer = createTestCustomer(bank.Id);
        insert customer;

        // Insert a primary card
        List<Card__c> primaryCards = createTestCards(customer.Id, true, bank.Id);
        insert primaryCards;

        // Insert additional non-primary cards
        List<Card__c> nonPrimaryCards = createTestCards(customer.Id, false, bank.Id);
        insert nonPrimaryCards;

        // Update some cards to be primary
        List<Card__c> cardsToUpdate = new List<Card__c>();
        for (Card__c card : nonPrimaryCards) {
            card.Is_This_Primary_Card__c = true;
            cardsToUpdate.add(card);
        }
        update cardsToUpdate;

        // Verify that updated cards are now primary
        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :cardsToUpdate];
        for (Card__c card : updatedCards) {
            System.assertEquals(true, card.Is_This_Primary_Card__c, 'Updated cards should be primary');
        }
    }
    // Additional test cases for other scenarios...

    private static Customers__c createTestCustomer(Id bankId) {
        return new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c = '1234567',
            Bank__c = bankId,
            Password__c = 'Password$20',
            User_name__c = 'testuser',
            PAN__c = 'BTVPV4305A',
            Date_of_Birth__c = Date.valueOf(System.now()),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = 'Z467',
            Email__c = 'test.user@cognizant.com',
            manager_mail__c = 'ujjwala.chavan@cognizant.com'
        );
    }

    private static List<Card__c> createTestCards(Id customerId, Boolean isPrimary,Id bankId) {
        List<Card__c> testCards = new List<Card__c>();
        for (Integer i = 0; i < 5; i++) {
            testCards.add(new Card__c(
                Card_Network__c = 'Visa',
                Card_Number__c = '6789564367890654',
                Expiry_Date__c = Date.today(),
                Select_your_Bank__c = bankId,
                Status__c = 'active',
                Customer__c = customerId,
                Type__c = (Math.mod(i, 2) == 0) ? 'Debit' : 'Credit',
                Is_This_Primary_Card__c = isPrimary,
                CVV__c = 123
            ));
        }
        return testCards;
    }
}
/*@isTest
public class PrimarycardTriggerHandlerTest {
    
    @isTest
    static void testInsert() {
        // Create a Bank record
        Bank__c bank = new Bank__c(Name='ICICU');
        insert bank;
        
        // Create a Customers record
        Customers__c customer = new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c='1234567',
            Bank__c = bank.Id,
            Password__c = 'Password$20',
            User_name__c = 'testuser',
            PAN__c = 'BTVPV4305A',
            Date_of_Birth__c = Date.valueOf(System.now()),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = 'Z467',
            Email__c = 'test.user@cognizant.com',
            manager_mail__c = 'ujjwala.chavan@cognizant.com'
        );
        insert customer;
        // Create test data
        List<Card__c> testCards = new List<Card__c>();
        for (Integer i = 0; i < 5; i++) {
            testCards.add(new Card__c(
                Card_Network__c = 'Visa',
                Card_Number__c = '6789564367890654',
                Expiry_Date__c = Date.valueOf(System.today()),
                Select_your_Bank__c = bank.Id,
                Status__c = 'active',
                Customer__c = customer.id,
                Type__c = (Math.mod(i, 2) == 0) ? 'Debit' : 'Credit',
                Is_This_Primary_Card__c = true,
                CVV__c=123
            ));
        }
        insert testCards;
        
        // Verify the primary card logic
        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :testCards];
        for (Card__c card : updatedCards) {
            System.assertEquals(card.Is_This_Primary_Card__c, true, 'Primary card should be set to true');
        }
    }
    
    @isTest
    static void testUpdate() {
        // Create test data
        // // Create a Bank record
        Bank__c bank = new Bank__c(Name='ICICU');
        insert bank;
        
        // Create a Customers record
        Customers__c customer = new Customers__c(
            Name = 'Test Customer',
            Customer_Id__c='1234567',
            Bank__c = bank.Id,
            Password__c = 'Password$20',
            User_name__c = 'testuser',
            PAN__c = 'BTVPV4305A',
            Date_of_Birth__c = Date.valueOf(System.now()),
            Mobile_Phone__c = '1234567890',
            Zip_Code__c = 'Z467',
            Email__c = 'test.user@cognizant.com',
            manager_mail__c = 'ujjwala.chavan@cognizant.com'
        );
        insert customer;
        List<Card__c> testCards = new List<Card__c>();
        for (Integer i = 0; i < 5; i++) {
            testCards.add(new Card__c(
                Card_Network__c = 'Visa',
                Card_Number__c = '6789564367890654',
                Expiry_Date__c = Date.valueOf(System.today()),
                Select_your_Bank__c = bank.Id,
                Status__c = 'active',
                Customer__c = customer.id,
                Type__c = (Math.mod(i, 2) == 0) ? 'Debit' : 'Credit',
                Is_This_Primary_Card__c = true,
                CVV__c=123
            ));
        }
        insert testCards;
        
        // Update the cards
        for (Card__c card : testCards) {
            card.Is_This_Primary_Card__c = false;
        }
        update testCards;
        
        // Verify the primary card logic after update
        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :testCards];
        for (Card__c card : updatedCards) {
            System.assertEquals(card.Is_This_Primary_Card__c, false, 'Primary card should be set to false after update');
        }
    }
}
*/