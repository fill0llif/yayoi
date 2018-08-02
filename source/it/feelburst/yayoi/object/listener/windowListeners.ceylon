import it.feelburst.yayoi.marker {
	listener
}

import java.awt.event {
	WindowAdapter,
	WindowEvent
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.context {
	ApplicationEventPublisher
}
import it.feelburst.yayoi.behaviour.listener.model {

	ShutdownRequested
}
listener
shared class DefaultWindowClosedAdapter() extends WindowAdapter() {
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	shared actual void windowClosing(WindowEvent? e) =>
		eventPublisher.publishEvent(ShutdownRequested(this));
}