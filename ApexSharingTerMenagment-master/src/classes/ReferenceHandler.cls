
public with sharing class ReferenceHandler {

    public static void onReferenceInsert(Reference__c ref) {
        Territory__c territory = [
                SELECT Id, Name, (SELECT Id, Name FROM Accounts__r)
                FROM Territory__c
                WHERE Id IN (SELECT Territory__c FROM Account WHERE Id = :ref.Account__c)
                LIMIT 1
        ];

        List<Territory__c> territoryHierarchy = TerritoryUtils.getTerritoryHierarchy(territory);

        List<TerrUser__c> terrUsers = [SELECT User__c, User__r.Name,User__r.IsActive FROM TerrUser__c WHERE Territory__c IN :territoryHierarchy];

        Set<SObject> shareItems = new Set<SObject>();
        for (TerrUser__c terrUser : terrUsers) {
            if (terrUser.User__r.IsActive) {
                AccountShare accountShare = new AccountShare();
                accountShare.AccountId = ref.Account__c;
                accountShare.AccountAccessLevel = 'Read';
                accountShare.OpportunityAccessLevel = 'Read';
                accountShare.UserOrGroupId = terrUser.User__c;
                shareItems.add(accountShare);

                ContactShare contactShare = new ContactShare();
                contactShare.ContactId = ref.Contact__c;
                contactShare.ContactAccessLevel = 'Read';
                contactShare.UserOrGroupId = terrUser.User__c;
                shareItems.add(contactShare);
            }
        }
        Database.SaveResult[] result = Database.insert(new List<SObject>(shareItems), false);

        for (Database.SaveResult sr : result) {
            if (!sr.isSuccess()) {
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                System.debug('Error: ' + err);
            }
        }
    }

    public static void onReferenceDelete(Reference__c ref) {
        // get all users with access to contact from ref
        List<User> users = [
                SELECT Id, Name
                FROM User
                WHERE User.Id IN (SELECT UserOrGroupId FROM ContactShare WHERE ContactId = :ref.Contact__c)
        ];

        // get the list of accounts with relation to contact
        List<Account> otherAccounts = [
                SELECT Id
                FROM Account
                WHERE Id IN (SELECT Account__c FROM Reference__c WHERE Contact__c = :ref.Contact__c AND Account__c != :ref.Account__c)
        ];

        for (User user : users) {
            List<AccountShare> accountShare = [SELECT Id FROM AccountShare WHERE UserOrGroupId = :user.Id AND AccountId IN :otherAccounts];
            if (accountShare.isEmpty()) {
                List<ContactShare> contactShare = [
                        SELECT Id, UserOrGroupId, RowCause
                        FROM ContactShare
                        WHERE UserOrGroupId = :user.Id AND ContactId = :ref.Contact__c AND RowCause = 'Manual'
                ];
                Database.DeleteResult[] result = Database.delete(contactShare);
                System.debug('deleted result: ' + result);
            }
        }
    }
}