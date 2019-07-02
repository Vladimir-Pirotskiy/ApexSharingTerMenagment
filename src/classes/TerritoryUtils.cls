public class TerritoryUtils {

    public static List<Territory__c> getTerritoryHierarchy(Id parentTerritoryId) {
        List<Territory__c> allTerritories = new List<Territory__c>();
        allTerritories.add([SELECT Id, Name FROM Territory__c WHERE Id = :parentTerritoryId]);
        List<Territory__c> territories = [SELECT Id, Name FROM Territory__c WHERE Territory__c = :parentTerritoryId];
        for (Territory__c territory : territories) {
            allTerritories.addAll(getTerritoryHierarchy(territory.Id));
        }
        return allTerritories;


    }
}