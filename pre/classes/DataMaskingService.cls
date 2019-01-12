/**
* @author davidbrowaeys[JS]
* @date 18/09/2018
* @description This class allow to mask any object
* @usage this can be simply be called as follow : 
* DataMaskingService.execute(scope);
* In order to execute the data masking from a trigger we can update the SObjectDomain class 
* by adding this like into the handleOnBeforeUpdate method as follow : 
* 
    public void handleBeforeUpdate(Map<Id,SObject> oldMap) {
        log.functionName = 'BeforeUpdate';
        onBeforeUpdate(oldMap);
        DataMaskingService.execute(records);
    }
* Each object to mask must have at least a trigger with before update action. 
* If trigger doesn't exist yet, it must be create manually by system admin. 
* Once the little method is added to the object domain layer and the trigger is created, 
* we can export ALL records (ID only) and perform a mass dummy update using bulk API mode. 
*/
public class DataMaskingService{
   	public static void execute(List<sObject> scope) {
		Map<String, Object> fieldValues = getTransformationRules(scope);
		
   		for(sObject obj : scope){
   			for(String fieldName : fieldValues.keySet()){
				if (fieldValues.get(fieldName) == null){
					obj.put(fieldName, null);
				}else if (String.valueOf(fieldValues.get(fieldName)) == 'random_email'){
					String value = generateRandomString2(10) + 'test.co';
					obj.put(fieldName, value);
				}else if (String.valueOf(fieldValues.get(fieldName)) == 'random_phone'){
					String value = '0'+ generateRandomNumber(9);
					obj.put(fieldName, value);
				}else if (String.valueOf(fieldValues.get(fieldName)) == 'random_date'){
					if (obj.get(fieldName) != null){
						Date d = Date.valueOf(obj.get(fieldName));
						d = d.addDays(generateRandomNumber(3));
						obj.put(fieldName, d);
					}
				}else if (String.valueOf(fieldValues.get(fieldName)) == 'random_name'){
					String value = generateRandomString2(10);
					obj.put(fieldName, value);
				}else if (String.valueOf(fieldValues.get(fieldName)) == 'random_street'){
					String value = '123 ' + generateRandomString2(10) + ' Street';
					obj.put(fieldName, value);
				}else if (String.valueOf(fieldValues.get(fieldName)).startsWith('random_num') == true){
					Integer value;
					if (String.valueOf(fieldValues.get(fieldName)).contains('::') == true){
						Integer len = Integer.valueOf(String.valueOf(fieldValues.get(fieldName)).split('::')[1]);
						value = generateRandomNumber(len);
                    }else{
                        value = generateRandomNumber(null);
                    }
					if (String.valueOf(fieldValues.get(fieldName)).startsWith('random_num_str') == true){
						obj.put(fieldName, String.valueOf(value));
					}else{
						obj.put(fieldName, value);
					}
				}else{
					obj.put(fieldName, fieldValues.get(fieldName));	
				}
   			}
   		}
	}

	private static Integer generateRandomNumber(Integer len) {
		String chars = '123456789';
		String[] result = new String[len];
		Integer idx = 0;

		while(idx < len) {
			Integer chr = Math.mod(Math.abs(Crypto.getRandomInteger()), 9);
			result[idx++] = chars.substring(chr, chr+1);
		}
		return Integer.valueOf(String.join(result,''));
	}

	private static String generateRandomString2(Integer len) {
		String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
		String[] result = new String[len];
		Integer idx = 0;

		while(idx < len) {
			Integer chr = Math.mod(Math.abs(Crypto.getRandomInteger()), 52);
			result[idx++] = chars.substring(chr, chr+1);
		}
		return String.join(result,'');
	}
	public static Boolean isPersonAccount = false;
	private static Map<String,Object> getTransformationRules(List<SObject> scope){
		String objectName = isPersonAccount == true ? 'PersonAccount' : scope.getSObjectType().getDescribe().getName();
		List<StaticResource> resources = [select Id, Body from StaticResource where Name =: ('DataMasking'+objectName) order by CreatedDate desc];
		if (resources == null){
			throw new SystemException('Fields transformation definiton file for ['+objectName+'] can not be found. Make sure you have added the definition file as a static resource, i.e.: DataMaskingAccount.json');
		}
		String contentJson = EncodingUtil.base64Decode(EncodingUtil.base64Encode(resources[0].Body)).toString();
		return (Map<String,Object>)JSON.deserializeUntyped(contentJson);
	}
}