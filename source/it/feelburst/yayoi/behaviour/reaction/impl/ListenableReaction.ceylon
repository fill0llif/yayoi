import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	ListenableAnnotation
}
import it.feelburst.yayoi.model {
	Declaration,
	Value
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
shared class ListenableReaction(
	shared actual AbstractComponent&Declaration&Value<Object> cmp,
	shared actual ListenableAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent&Declaration&Value<Object>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value lstnrName = nmRslvr.resolveNamed(cmp.decl,ann);
		value listener = context.getBean(lstnrName,classForType<Listener<Object>>());
		value addListener = ann.agent(cmp.listeners);
		addListener(listener);
		log.debug("Reaction: Listener '``listener``' set requested for Window '``cmp``'.");
	}
}
