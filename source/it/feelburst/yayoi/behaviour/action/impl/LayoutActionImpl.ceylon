import it.feelburst.yayoi {
	ActionDecl
}
import it.feelburst.yayoi.behaviour.action {
	AbstractAction,
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.container {
	Container
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
shared class LayoutActionImpl(
	shared actual String name,
	shared actual ActionDecl decl,
	ApplicationContext context)
	extends AbstractAction(name,decl)
	satisfies LayoutAction {
	
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(decl,ann);
		value name = "``containingPckg``.``ann.container``";
		value cnt = context.getBean(
			name,
			classForType<Container<JContainer,LayoutManager>>());
		assert (exists lyt = cnt.layout);
		value srcCmps = cnt.components.narrow<Source<JContainer>>();
		decl.invoke([],lyt.val,cnt.val,*(srcCmps*.val));
		log.info(
			"Layout Action '``this.name``' executed on Layout '``lyt``' " +
			"with Components ``srcCmps``.");
	}
}