trigger DataMaskingLead on Lead (before update){
	DataMaskingService.execute(Trigger.new);
}