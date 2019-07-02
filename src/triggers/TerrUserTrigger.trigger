trigger TerrUserTrigger on TerrUser__c (after insert, after delete, after undelete) {

    if (Trigger.isInsert) {
        for (TerrUser__c terrUser : Trigger.new) {
            TerrUserHandler.onTerrUserInsert(terrUser);
        }
    }

    if (Trigger.isDelete) {
        for (TerrUser__c terrUser : Trigger.new) {
            TerrUserHandler.onTerrUserDelete(terrUser);
        }
    }

    if(Trigger.isUndelete) {
        for (TerrUser__c terrUser : Trigger.new) {
            TerrUserHandler.onTerrUserInsert(terrUser);
        }
    }

}
