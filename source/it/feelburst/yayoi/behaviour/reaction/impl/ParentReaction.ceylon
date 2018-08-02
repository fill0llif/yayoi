import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	ParentAnnotation
}
import it.feelburst.yayoi.model {
	Source
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
import it.feelburst.yayoi.behaviour.component {

	NameResolver
}
"A reaction that sets a parent's component"
shared class ParentReaction(
	shared actual AbstractComponent&Source<> cmp,
	shared actual ParentAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent&Source<>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value cntrName = "``containingPckg``.``ann.name``";
		value setParent = ann.agentMdl(cmp);
		value cntr = context.getBean(cntrName,classForType<AbstractContainer>());
		setParent(cntr);
		log.info("Parent Container '``cntr``' set on Component '``cmp``'.");
		cntr.addComponent(cmp);
		log.info("Component '``cmp``' added to Container '``cntr``'.");
	}
}