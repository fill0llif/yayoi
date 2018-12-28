import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Independent
}
import it.feelburst.yayoi.marker {
	SizeAnnotation
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.concurrent {
	Lock
}

import java.util.concurrent.locks {
	Condition
}

import org.springframework.context {
	ApplicationContext
}

"A reaction that sets the size of a component"
shared class SizeReaction(
	shared actual AbstractComponent cmp,
	shared actual SizeAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<AbstractComponent>&Independent {
	value depender = IndependentImpl();
	shared actual Lock lock =>
		depender.lock;
	shared actual Condition doneExecuting =>
		depender.doneExecuting;
	shared actual void signalDependent() =>
		depender.signalDependent();
	shared actual void execute() {
		value setSize = ann.agent(cmp);
		setSize(ann.width, ann.height);
		log.debug("Reaction: Size (``ann.width``,``ann.height``) set requested for Component '``cmp``'.");
	}
	
}
