trigger DataMaskingContact on Contact (before update){
	DataMaskingService.execute(Trigger.new);
}