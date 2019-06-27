trigger AccountTrigger on Account (after update) {
    if (Trigger.isUpdate) {
        for (Account account : Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(account.Id);
            AccountHandler.onAccountUpdate(account, oldAccount);
        }
    }
}