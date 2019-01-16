import ceylon.interop.java {
	CeylonMap
}

import it.feelburst.yayoi.behaviour.listener.model {
	Closed
}
import it.feelburst.yayoi.marker {
	listener,
	collectable
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.\iobject.setting.awt {
	awtWindowAwtWindowListener
}

import java.awt {
	JWindow=Window
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
collectable(`value awtWindowAwtWindowListener`)
shared class DefaultWindowClosingAdapter() extends WindowAdapter() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	shared actual void windowClosing(WindowEvent e) {
		//find closing window
		assert (exists wndwName -> wndw = CeylonMap(context
		.getBeansOfType(classForType<Window<JWindow>>()))
		.find((JString name -> Window<JWindow> window) =>
			window.val == e.window));
		eventPublisher.publishEvent(Closed(wndw));
	}
}
