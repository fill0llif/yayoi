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
import java.util.concurrent {
	FutureTask
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}

import org.springframework.context {
	ApplicationContext
}
shared final class AwtLayoutAction(
	shared actual String name,
	shared actual FunctionDeclaration decl,
	ApplicationContext context)
	extends AbstractAction(name,decl)
	satisfies LayoutAction {
	
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value cmpRgstr = context.getBean(classForType<ComponentRegistry>());
		value cntName = nmRslvr.resolveNamed(decl,ann);
		value cnt = context.getBean(
			cntName,
			classForType<Container<Object>>());
		if (exists lyt = cnt.layout) {
			value cntrCmps = cnt.items.sequence();
			value atwrdIntrnlActFtr =
			let (atwrdIntrnlAct = cmpRgstr.autowired<>(this.name,decl))
			FutureTask<Anything>(() =>
				atwrdIntrnlAct());
			invokeLater(atwrdIntrnlActFtr);
			if (is Exception actRslt = atwrdIntrnlActFtr.get()) {
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
