import it.feelburst.yayoi.behaviour.listener.model {
	ShutdownRequested
}

import org.springframework.context.event {
	eventListener
}
import org.springframework.stereotype {
	component
}
import org.springframework.context.annotation {

	AnnotationConfigApplicationContext
}
import org.springframework.beans.factory.annotation {

	autowired
}
component
shared class ApplicationListener() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	eventListener
	shared void handleShutdownRequested(ShutdownRequested event) {
		log.info("Application shutting down...");
		context.close();
	}
	
}