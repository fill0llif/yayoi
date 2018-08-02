import ceylon.logging {
	Logger,
	logger,
	info
}
Logger log {
	value log = logger(`package it.feelburst.yayoi.model.component.swing`);
	log.priority = info;
	return log;
}
