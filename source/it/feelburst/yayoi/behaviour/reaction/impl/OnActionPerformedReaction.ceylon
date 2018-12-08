import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	OnActionPerformedAnnotation
}
import it.feelburst.yayoi.model {
	Declaration
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
"A reaction that adds an action listener to a component"
shared class OnActionPerformedReaction(
	shared actual AbstractComponent&Declaration cmp,
	shared actual OnActionPerformedAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent&Declaration> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value lstnrName = "``containingPckg``.``ann.listener``";
		value listener = context.getBean(lstnrName,classForType<Listener<Object>>());
		value addListener = ann.agentMdl(cmp);
		addListener(listener);
		log.debug("Reaction: Listener '``listener``' set requested for Component '``cmp``'.");
	}
}
