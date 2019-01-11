/**
* @author: davidbrowaeys[SMS]
* @description: This class allow to mass update records
* @usage: Database.executeBatch(new SystemMassUpdateRecordsBatch('SELECT Id, MyField__c FROM Account', new Map<String,Object>{'MyField__c' => 'MyValue'}));
* Advanced usage: 
*	Database.executeBatch(new SystemMassUpdateRecordsBatch('SELECT Id, MyField__c, MyField2__c, MyField3__c, MyField4__c, MyParent__r.MyField5__c FROM Account', new Map<String,Object>{'MyField__c’ => 1, ‘MyField2__c’ => ‘fd::MyField3__c’, ‘MyField4__c’ => ‘pfd::MyParent__r.MyField5__c’}));
*/
global class SystemMassUpdateRecordsBatch implements Database.Batchable<sObject> {

	String query;
	Map<String, Object> fieldValues;

	/**
	 * @description Batch Constructor
	 * @param query 	sql query for the mass update
	 * @param fieldValues	map of field to update with the respective values
	 */
	global SystemMassUpdateRecordsBatch(String query, Map<String, Object> fieldValues) {
		this.query = query;
		this.fieldValues = fieldValues;
	}
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}
	/**
	 * @description Execure batch which loops over each sObject returned in previous query,
	 * then loops over each field returned, and finally places the corresponding value inside the previous Map to each the corresponding field.
	 */
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		DataMaskingService.execute(scope);

   		if(!Test.isRunningTest()) update scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('EOB >> '+query);
	}
}