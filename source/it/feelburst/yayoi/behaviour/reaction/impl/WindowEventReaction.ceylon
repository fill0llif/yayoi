import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	WindowEventAnnotation
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.awt.event {
	WindowListener
}
import java.lang {
	Types {
		classForType
	}
}
import java.util {
	EventListener
}

import javax.swing {
	JFrame
}

import org.springframework.context {
	ApplicationContext
}
import it.feelburst.yayoi.behaviour.component {

	NameResolver
}
"A reaction that adds a window listener to a window"
shared class WindowEventReaction(
	shared actual Window<JFrame> cmp,
	shared actual WindowEventAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<Window<JFrame>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value lstnrName = "``containingPckg``.``ann.listener``";
		value listener = context.getBean(lstnrName,classForType<Listener<EventListener>>());
		value addListener = ann.agentMdl(cmp);
		addListener(listener);
		log.info("Listener '``listener``' added to Component '``cmp``'.");
		//TODO get addWindowListener in SwingComponent
		//TODO because now (31/07/2018) ceylon has still problems with swing
		assert (is WindowListener wndwLstnr = listener.val);
		cmp.val.addWindowListener(wndwLstnr);
		log.info("WindowListener '``wndwLstnr``' added to SwingWindow '``cmp.val``'.");
	}
}