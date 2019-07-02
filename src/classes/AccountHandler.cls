public with sharing class AccountHandler {

    public static void onAccountUpdate(Account account, Account oldAccount) {
        if (account.Territory__c != oldAccount.Territory__c) {
            List<Territory__c> territoryHierarchy = TerritoryUtils.getTerritoryHierarchy(account.Territory__c);
            List<TerrUser__c> terrUsers = [SELECT User__c, User__r.Name,User__r.IsActive FROM TerrUser__c WHERE Territory__c IN :territoryHierarchy AND User__r.IsActive = TRUE];

            List<SObject> sharesToDelete = new List<SObject>();
            for (TerrUser__c terrUser : terrUsers) {
                List<AccountShare> accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :terrUser.User__c AND AccountId = :account.Id];
                sharesToDelete.addAll(accountShares);

                List<ContactShare> contactShares = [
                        SELECT Id
                        FROM ContactShare
                        WHERE UserOrGroupId = :terrUser.User__c AND ContactId IN (SELECT Contact__c FROM Reference__c WHERE Id = :account.Id)
                ];
                sharesToDelete.addAll(contactShares);
            }
            Database.delete(sharesToDelete);

            List<Reference__c> references = [SELECT Id FROM Reference__c WHERE Account__c = :account.Id];
            for (Reference__c ref : references) {
                ReferenceHandler.onReferenceInsert(ref);
            }
        }

    }
}