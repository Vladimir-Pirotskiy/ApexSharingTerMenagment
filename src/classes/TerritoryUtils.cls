
public class TerritoryUtils {

    public static List<Territory__c> getTerritoryHierarchy(Territory__c parentTerritory) {
        List<Territory__c> allTerritories = new List<Territory__c>();
        allTerritories.add(parentTerritory);
        List<Territory__c> territories = [SELECT Id, Name FROM Territory__c WHERE Territory__c = :parentTerritory.Id];
        for (Territory__c territory : territories) {
            allTerritories.addAll(getTerritoryHierarchy(territory));
        }
        return allTerritories;
    }
}
