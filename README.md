Step to mask data in PPT and UAT. 

Objects: Lead, Account, Contact, 
Fields: 

1. Import create manually the following class : DataService. This class can be found in our EntCRM repo under script/datamasking. 
2. Update SObjectDomain.handleBeforeUpdate as follow : 

    public void handleBeforeUpdate(Map<Id,SObject> oldMap) {
        log.functionName = 'BeforeUpdate';
        onBeforeUpdate(oldMap);
        DataMaskingService.execute(records);
    }

3. create/update trigger for target object : 
    1. if trigger exist for a particular object, make sure the before update is referenced in the trigger. 
        the object handler class do not need to override the onBeforeUpdate. The object domain will handle it as you update the object domain layer at step 2. 
    2. if there is not trigger created yet for that particular object, create a new one as follow: 
        trigger MyObjectTrigger on MyObject__c (before update){
            DataMaskingService.execute(Trigger.new);
        }
    this is only a temporary trigger you do not need to use the object domain layer. You will be deleting this later on. 
    If you feel more confortable you can create new trigger for ALL target object regardless of the core apex code. 

4. Export all records of target object (ID's only) using Data Loader or Report

5. Still using data loader (or sfdx explained below), perform an update of all records by mapping ID only. 
MAKE SURE BULK API MODE IS ENABLED

6. Clean up everything : 
    1. Delete created temporary trigger
    2. Update SObjectDomain back

Update data using SFDX : 
1. Export all data : 
sfdx force:data:soql:query -q "SELECT Id FROM Contact" -u ppt -r csv > contact_ids.csv

2. Bulk update data : 
sfdx force:data:bulk:upsert -s Contact -f ./contact_ids.csv -i Id -u ppt 


Automated solution using Jenkins : 
- Jenkins should deploy the data masking package under script/datamasking folder. This folder should include all the changes necessary to perform the data masking : 
    1. data masking service class
    2. trigger for target objects
- Jenkins should then export data using SFDX as explained above. Again export should only contains the ID's of the records... How long is this using DX ????
- Jenkins should update ALL data using SFDX as explained above. 
- Jenkins should rollback changes by deploying a destructive changes