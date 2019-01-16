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
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
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
		value cntrName = nmRslvr.resolveNamed(cmp.decl,ann);
		value cntr = context.getBean(cntrName,classForType<AbstractCollection>());
		cmp.parent = cntr;
		log.debug("Reaction: Parent Container '``cntr``' set requested for Component '``cmp``'.");
	}
}
