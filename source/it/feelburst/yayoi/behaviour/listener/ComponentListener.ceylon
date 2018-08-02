import it.feelburst.yayoi.behaviour.listener.model {
	IndependentDoneExecuting
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Independent
}
import it.feelburst.yayoi.model {
	Reactor
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context.event {
	eventListener
}
import org.springframework.stereotype {
	component
}
component
shared class ComponentListener() {
	
	"Signal dependent (independent already been executed)"
	eventListener
	shared void handleIndependentDoneExecuting(IndependentDoneExecuting event) {
		assert (
			is Reactor rctr = event.source,
			is Reaction<AbstractComponent>&Independent independentRctn = 
				rctr.reactions
				.find(event.isIndependent));
		independentRctn.signalDependent();
	}
	
}