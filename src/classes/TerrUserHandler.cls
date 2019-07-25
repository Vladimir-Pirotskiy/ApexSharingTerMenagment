public with sharing class TerrUserHandler {

    public static void onTerrUserInsert(TerrUser__c terrUser) {

        List<Territory__c> territoryHierarchy = TerritoryUtils.getTerritoryHierarchy(terrUser.Territory__c);

        List<Account> accounts = [SELECT Name, Territory__r.Id, Territory__r.Name FROM Account WHERE Territory__c IN :territoryHierarchy];

        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE Id IN (SELECT Contact__c FROM Reference__c WHERE Account__c IN :accounts)];


        Set<SObject> shareItems = new Set<SObject>();
        for (Account account : accounts) {
            AccountShare accountShare = new AccountShare();
            accountShare.AccountId = account.Id;
            accountShare.AccountAccessLevel = 'Read';
            accountShare.OpportunityAccessLevel = 'Read';
            accountShare.UserOrGroupId = terrUser.User__c;
            shareItems.add(accountShare);
        }
        for (Contact contact : contacts) {
            ContactShare contactShare = new ContactShare();
            contactShare.ContactId = contact.Id;
            contactShare.ContactAccessLevel = 'Read';
            contactShare.UserOrGroupId = terrUser.User__c;
            shareItems.add(contactShare);
        }
        System.debug('shareItems: ' + shareItems);
        Database.SaveResult[] result = Database.insert(new List<SObject>(shareItems), false);

        for (Database.SaveResult sr : result) {
            if (!sr.isSuccess()) {
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                System.debug('Error: ' + err);
            }

        }

    }
    public static void onTerrUserDelete(TerrUser__c terrUser) {

        List<AccountShare> accountShares = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :terrUser.User__c];

        List<ContactShare> contactShares = [SELECT Id FROM ContactShare WHERE UserOrGroupId = :terrUser.User__c];

        List<SObject> shares = new List<SObject>();

        shares.addAll(accountShares);
        shares.addAll(contactShares);

        Database.DeleteResult[] results = Database.delete(shares);

        for (Database.DeleteResult sr : results) {
            if (!sr.isSuccess()) {
                // Get the first delete result error
                Database.Error err = sr.getErrors()[0];
                System.debug('Error: ' + err);
            }

        }

    }
}