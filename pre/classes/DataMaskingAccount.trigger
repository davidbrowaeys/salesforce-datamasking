trigger DataMaskingAccount on Account (before update){
	DataMaskingService.isPersonAccount = Trigger.new[0].IsPersonAccount;
	DataMaskingService.execute(Trigger.new);
}