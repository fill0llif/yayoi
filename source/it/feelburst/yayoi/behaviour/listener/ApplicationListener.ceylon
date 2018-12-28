import it.feelburst.yayoi.behaviour.listener.model {
	ShutdownRequested
}
import it.feelburst.yayoi.model.window {
	Window
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
import org.springframework.context.event {
	eventListener
}
import org.springframework.stereotype {
	component
}
import java.lang {
	Types {
		classForType
	}
}
import ceylon.interop.java {

	CeylonCollection
}

component
shared class ApplicationListener() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	eventListener
	shared void handleShutdownRequested(ShutdownRequested event) {
		CeylonCollection(context
			.getBeansOfType(classForType<Window<Object>>())
			.values())
		.each((Window<Object> wndw) =>
			wndw.close());
	}
	
}