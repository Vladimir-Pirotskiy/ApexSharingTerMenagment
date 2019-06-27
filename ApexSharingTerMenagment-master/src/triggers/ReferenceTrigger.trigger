trigger ReferenceTrigger on Reference__c (after insert, after delete, after undelete) {
    if (Trigger.isInsert) {
        for (Reference__c ref : Trigger.new) {
            ReferenceHandler.onReferenceInsert(ref);
        }
    }

    if (Trigger.isDelete) {
        for (Reference__c ref : Trigger.old) {
            ReferenceHandler.onReferenceDelete(ref);
        }
    }

    if(Trigger.isUndelete) {
        for (Reference__c ref : Trigger.new) {
            ReferenceHandler.onReferenceInsert(ref);
        }
    }
}
