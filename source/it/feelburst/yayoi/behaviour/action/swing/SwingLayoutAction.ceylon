import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	AbstractAction,
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	NameResolver,
	ComponentRegistry
}
import it.feelburst.yayoi.model.container {
	Container
}

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
shared final class SwingLayoutAction(
	shared actual String name,
	shared actual FunctionDeclaration decl,
	ApplicationContext context)
	extends AbstractAction(name,decl)
	satisfies LayoutAction {
	
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value cmpRgstr = context.getBean(classForType<ComponentRegistry>());
		value containingPckg = nmRslvr.resolveRoot(decl,ann);
		value name = "``containingPckg``.``ann.container``";
		value cnt = context.getBean(
			name,
			classForType<Container<Object,Object>>());
		if (exists lyt = cnt.layout) {
			value cntrCmps = cnt.components.sequence();
			value atwrdIntrnlAct = cmpRgstr.autowired<>(this.name,decl);
			if (is Exception actRslt = atwrdIntrnlAct()) {
				throw actRslt;
			}
			else {
				log.info(
					"Action: Layout Action '``this.name``' executed on Layout '``lyt``' " +
					"with Components ``cntrCmps``.");
			}
		}
		else {
			throw Exception(
				"Cannot execute Layout Action '``this.name``'. Layout of container '``cnt``' " +
				"not found.");
		}
	}
}
