import it.feelburst.yayoi.behaviour.listener.model {
	ShutdownRequested
}
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
listener
shared class DefaultWindowClosingAdapter() extends WindowAdapter() {
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	shared actual void windowClosing(WindowEvent e) =>
		eventPublisher.publishEvent(ShutdownRequested());
}
