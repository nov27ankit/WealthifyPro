public class primarycardTriggerHandler {
    public static void handleCard(List<Card__c> newCards){
        List<ID> creditId=new list<ID>();
        List<ID> debitId=new list<ID>();
        List<ID> debit = new List<Id>();
        List<ID> credit = new List<ID>();
        Set<ID> customerId=new Set<ID>();
        List<Card__c> cards=new List<Card__c>();
        
        for(Card__c card : newCards){
            if(card.Is_This_Primary_Card__c){
                if(card.Type__c=='Debit'){
                    debitId.add(card.Id);
                }
                if(card.Type__c=='Credit'){
                    creditId.add(card.Id);
                }
                customerId.add(card.Customer__c);
            }
            else{
                if(card.Type__c=='Debit'){
                    customerId.add(card.Customer__c);
                    List<Card__c> existingDebit = [SELECT Id, Customer__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='Debit'];
                    if(existingDebit.size()==0){
                        card.Is_This_Primary_Card__c=true;
                        cards.add(card);
                    }
                }
                if(card.Type__c=='Credit'){
                    customerId.add(card.Customer__c);
                    List<Card__c> existingCredit = [SELECT Id, Customer__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='credit'];
                    if(existingCredit.size()==0){
                        card.Is_This_Primary_Card__c=true;
                        cards.add(card);
                    }
                }
                
            }
        }
        
        if(creditId.size()>0){
            List<Card__c> creditList=[SELECT Id, Customer__c, Is_This_Primary_Card__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='Credit' and ID not in :creditId and Is_This_Primary_Card__c=true];
            for(Card__c card :creditList){
                card.Is_This_Primary_Card__c=false;
                cards.add(card);
            }
        } 
        if(debitId.size()>0){
            List<Card__c> debitList=[SELECT Id, Customer__c, Is_This_Primary_Card__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='Debit' and ID not in :debitId and Is_This_Primary_Card__c=true];
            for(Card__c card :debitList){
                card.Is_This_Primary_Card__c=false;
                cards.add(card);
            }
        } 
        update cards;
        
    }
    
    public static void handleUpdateCards(List<Card__c> newCards){
        List<ID> creditId=new list<ID>();
        List<ID> debitId=new list<ID>();
        Set<ID> customerId=new Set<ID>();
        
        for(Card__c card : newCards){
            if(card.Is_This_Primary_Card__c){
                if(card.Type__c=='Debit'){
                    debitId.add(card.Id);
                }
                if(card.Type__c=='Credit'){
                    creditId.add(card.Id);
                }
                customerId.add(card.Customer__c);
            }
        }
        List<Card__c> cards=new List<Card__c>();
        if(creditId.size()>0){
            List<Card__c> creditList=[SELECT Id, Customer__c, Is_This_Primary_Card__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='Credit' and ID not in :creditId and Is_This_Primary_Card__c=true];
            for(Card__c card :creditList){
                card.Is_This_Primary_Card__c=false;
                cards.add(card);
            }
        } 
        if(debitId.size()>0){
            List<Card__c> debitList=[SELECT Id, Customer__c, Is_This_Primary_Card__c, Type__c FROM Card__c WHERE Customer__c IN : customerId AND Type__c='Debit' and ID not in :debitId and Is_This_Primary_Card__c=true];
            for(Card__c card :debitList){
                card.Is_This_Primary_Card__c=false;
                cards.add(card); 
            }
        } 
        update cards;
    }
}