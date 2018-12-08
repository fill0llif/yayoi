import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
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

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
"A reaction that adds a window listener to a window"
shared class WindowEventReaction(
	shared actual Window<Object> cmp,
	shared actual WindowEventAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<Window<Object>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value lstnrName = "``containingPckg``.``ann.listener``";
		value listener = context.getBean(lstnrName,classForType<Listener<Object>>());
		value addListener = ann.agentMdl(cmp);
		addListener(listener);
		log.debug("Reaction: Listener '``listener``' set requested for Window '``cmp``'.");
	}
}
