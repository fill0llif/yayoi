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

import java.awt {
	LayoutManager,
	JContainer=Container
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
"A reaction that sets the layout of a container"
shared class WithLayoutReaction(
	shared actual Container<JContainer,LayoutManager> cmp,
	shared actual WithLayoutAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<Container<JContainer,LayoutManager>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value lytName = "``containingPckg``.``ann.layout``";
		value lyt = context.getBean(lytName,classForType<Layout<LayoutManager>>());
		value setLayout = ann.agentMdl(cmp);
		setLayout(lyt);
		log.info("Layout '``lyt``' set for Container '``cmp``'.");
	}
}