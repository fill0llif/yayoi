import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	WithLayoutAnnotation
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
"A reaction that sets the layout of a container"
shared class WithLayoutReaction(
	shared actual Container<Object,Object> cmp,
	shared actual WithLayoutAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<Container<Object,Object>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value lytName = nmRslvr.resolveNamed(cmp.decl,ann);
		value lyt = context.getBean(lytName,classForType<Layout<Object>>());
		value setLayout = ann.agent(cmp);
		setLayout(lyt);
		log.debug("Reaction: Layout '``lyt``' set requested for Container '``cmp``'.");
	}
}
