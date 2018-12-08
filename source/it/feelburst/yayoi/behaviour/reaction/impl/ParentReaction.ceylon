import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	ParentAnnotation
}
import it.feelburst.yayoi.model {
	Declaration
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
"A reaction that sets a parent's component"
shared class ParentReaction(
	shared actual AbstractComponent&Declaration cmp,
	shared actual ParentAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent&Declaration> {
	
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value cntrName = "``containingPckg``.``ann.name``";
		value cntr = context.getBean(cntrName,classForType<AbstractContainer>());
		value addComponent = ann.agentMdl(cntr);
		addComponent(cmp);
		log.debug("Reaction: Parent Container '``cntr``' set requested for Component '``cmp``'.");
	}
}
