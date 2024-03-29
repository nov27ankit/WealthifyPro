public class InsuranceController {
    public Insurance__c insure { get; set; }
    public Id insureId { get; set; }
    public Customers__c customer { get; set; }
    public Associated_Parties__c ap { get; set; }
    public Associated_Parties__c pd { get; set; }
    public String customerId { get; set; }

    public InsuranceController() {
        insureId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug(insureId);

        Insurance__c ins=[Select id,Name,Customer__c From Insurance__c where id=: insureId];
        
        customerId = ins.Customer__c;
        system.debug(customerId);
        

        loadData();
    }

    public void loadData() {
        AppDataController.DataWrapper data = AppDataController.retrieveData(customerId, insureId);

        if (data != null) {
            if (data.insuranceMap != null && data.insuranceMap.containsKey(insureId)) {
                insure = data.insuranceMap.get(insureId);
            }
            if (data.customerMap != null && data.customerMap.containsKey(insure.Customer__c)) {
                customer = data.customerMap.get(insure.Customer__c);
            }
           if (data.associatedPartiesMap != null && data.associatedPartiesMap.containsKey(insureId)) {
    List<Associated_Parties__c> associatedParties = data.associatedPartiesMap.get(insureId);
    for (Associated_Parties__c party : associatedParties) {
        if (party.Relationship__c == 'Beneficiary') {
            ap = party;
        } else if (party.Relationship__c == 'Policyholder') {
            pd = party;
        }
    }
}
        }
    }
}