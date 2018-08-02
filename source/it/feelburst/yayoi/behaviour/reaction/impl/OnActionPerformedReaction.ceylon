import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	OnActionPerformedAnnotation
}
import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.awt {
	Container
}
import java.awt.event {
	ActionListener
}
import java.lang {
	Types {
		classForType
	}
}
import java.util {
	EventListener
}

import javax.swing {
	AbstractButton
}

import org.springframework.context {
	ApplicationContext
}
import it.feelburst.yayoi.behaviour.component {

	NameResolver
}
"A reaction that adds an action listener to a component"
shared class OnActionPerformedReaction(
	shared actual AbstractComponent&Source<Container> cmp,
	shared actual OnActionPerformedAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent&Source<>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value containingPckg = nmRslvr.resolveRoot(cmp.decl,ann);
		value lstnrName = "``containingPckg``.``ann.listener``";
		value listener = context.getBean(lstnrName,classForType<Listener<EventListener>>());
		value addListener = ann.agentMdl(cmp);
		addListener(listener);
		log.info("Listener '``listener``' added to Component '``cmp``'.");
		//TODO get addActionListener in SwingComponent
		//TODO because now (31/07/2018) ceylon has still problems with swing
		assert (is AbstractButton btn = cmp.val);
		assert (is ActionListener actnLstnr = listener.val);
		btn.addActionListener(actnLstnr);
		log.info("ActionListener '``actnLstnr``' added to SwingButton '``btn``'.");
	}
}