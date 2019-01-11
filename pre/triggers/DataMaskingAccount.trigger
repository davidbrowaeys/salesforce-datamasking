trigger DataMaskingAccount on Account (before update){
	DataMaskingService.IsPersonAccount = Trigger.new[0].isPersonAccount == true;
	DataMaskingService.execute(Trigger.new);
}