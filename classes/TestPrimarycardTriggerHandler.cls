@isTest
private class TestPrimarycardTriggerHandler {
/*
    @isTest
    static void testHandleCard() {
        // Create test data for Card__c with required fields
        Card__c debitCard = new Card__c(Name = 'Debit Card', Type__c = 'Debit', Is_This_Primary_Card__c = true, CVV__c = 234, Customer__c = 'a045i00000NJSQoAAP', Select_your_Bank__c = 'a035i00000H5NeJAAV');
        Card__c creditCard = new Card__c(Name = 'Credit Card', Type__c = 'Credit', Is_This_Primary_Card__c = true, CVV__c = 234, Customer__c = 'a045i00000NJSQoAAP', Select_your_Bank__c = 'a035i00000H5NeJAAV');
        insert new List<Card__c>{debitCard, creditCard};

        Test.startTest();
        primarycardTriggerHandler.handleCard([SELECT Id, Type__c, Is_This_Primary_Card__c, Customer__c FROM Card__c WHERE Id IN :new List<Card__c>{debitCard, creditCard}]);
        Test.stopTest();

        // Use System.assert statements to validate the expected behavior
        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :new List<Card__c>{debitCard, creditCard}];
        System.assertEquals(2, updatedCards.size(), 'There should be one card updated');
        System.assertEquals(true, updatedCards[0].Is_This_Primary_Card__c, 'Only one card should remain as primary');
    }

    @isTest
    static void testHandleUpdateCards() {
        // Create test data for Card__c with required fields
        Card__c debitCard = new Card__c(Name = 'Debit Card', Type__c = 'Debit', Is_This_Primary_Card__c = true, CVV__c = 234, Customer__c = 'a045i00000NJSQoAAP', Select_your_Bank__c = 'a035i00000H5NeJAAV');
        Card__c creditCard = new Card__c(Name = 'Credit Card', Type__c = 'Credit', Is_This_Primary_Card__c = true, CVV__c = 234, Customer__c = 'a045i00000NJSQoAAP', Select_your_Bank__c = 'a035i00000H5NeJAAV');
        insert new List<Card__c>{debitCard, creditCard};

        // Trigger the update event to invoke handleUpdateCards method
        debitCard.Is_This_Primary_Card__c = false;
        creditCard.Is_This_Primary_Card__c = false;
        Test.startTest();
        primarycardTriggerHandler.handleUpdateCards([SELECT Id, Type__c, Is_This_Primary_Card__c, Customer__c FROM Card__c WHERE Id IN :new List<Card__c>{debitCard, creditCard}]);
        Test.stopTest();

        // Use System.assert statements to validate the expected behavior
        List<Card__c> updatedCards = [SELECT Id, Is_This_Primary_Card__c FROM Card__c WHERE Id IN :new List<Card__c>{debitCard, creditCard}];
        System.assertEquals(2, updatedCards.size(), 'Both cards should be updated');
        for (Card__c card : updatedCards) {
            System.assertEquals(true, card.Is_This_Primary_Card__c, 'All cards should be set as not primary');
        }
    }

   */
}