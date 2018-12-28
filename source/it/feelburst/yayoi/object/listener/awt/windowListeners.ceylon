import ceylon.interop.java {
	CeylonMap
}

import it.feelburst.yayoi.behaviour.listener.model {
	Closed
}
import it.feelburst.yayoi.marker {
	listener
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.awt.event {
	WindowAdapter,
	WindowEvent
}
import java.lang {
	JString=String,
	Types {
		classForType
	}
}

import javax.swing {
	JFrame,
	JDialog,
	JWindow
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.context {
	ApplicationEventPublisher
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}

listener
shared class DefaultWindowClosingAdapter() extends WindowAdapter() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	shared actual void windowClosing(WindowEvent e) {
		//find closing window
		assert (exists wndwName -> wndw = CeylonMap(context
		.getBeansOfType(classForType<Window<JFrame|JDialog|JWindow>>()))
		.find((JString name -> Window<JFrame|JDialog|JWindow> window) =>
			window.val == e.window));
		eventPublisher.publishEvent(Closed(wndw));
	}
}
