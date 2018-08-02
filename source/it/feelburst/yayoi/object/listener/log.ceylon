import ceylon.logging {
	Logger,
	logger,
	info
}
Logger log {
	value log = logger(`package it.feelburst.yayoi.\iobject.listener`);
	log.priority = info;
	return log;
}
