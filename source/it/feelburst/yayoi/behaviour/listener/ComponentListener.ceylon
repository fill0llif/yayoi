import ceylon.interop.java {
	CeylonMap
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.listener.model {
	IndependentDoneExecuting,
	ComponentAdded,
	SizeSet
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Independent
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	ParentReaction,
	SizeReaction
}
import it.feelburst.yayoi.model {
	Reactor,
	Declaration
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import java.lang {
	JString=String,
	Types
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.context {
	ApplicationEventPublisher
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
import org.springframework.context.event {
	eventListener
}
import org.springframework.stereotype {
	component
}
component
shared class ComponentListener() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	eventListener
	shared void handleSizeSet(SizeSet event) {
		eventPublisher.publishEvent(IndependentDoneExecuting(
			event.source,
			(Reaction<Object> rctn) =>
				rctn is SizeReaction));
	}
	
	"Signal dependent (independent already been executed)"
	eventListener
	shared void handleIndependentDoneExecuting(IndependentDoneExecuting event) {
		assert (
			is Reactor rctr = event.source,
			is Reaction<AbstractComponent>&Independent independentRctn = 
				rctr.reactions<AbstractComponent>()
				.find(event.isIndependent));
		independentRctn.signalDependent();
	}
	
	"Decide whether or not to add a component to a container"
	eventListener
	shared void handleComponentAdded(ComponentAdded event) {
		//if there are no layout actions, container's layout has not been addressed,
		//therefore components must be added to the container at framework impl level
		//if component has a parent
		if (is Reactor&Declaration cmp = event.component,
			exists prntRctn = cmp.reactions<>()
			.narrow<ParentReaction>()
			.find((ParentReaction reaction) =>
				reaction.cmp == event.component)) {
			//get container
			value nmRslvr = context.getBean(Types.classForType<NameResolver>());
			value containingPckg = nmRslvr.resolveRoot(cmp.decl,prntRctn.ann);
			value cntrName = "``containingPckg``.``prntRctn.ann.name``";
			value lytActns = CeylonMap(context.getBeansOfType(Types.classForType<LayoutAction>()));
			//if exists a layout action for the container
			if (!lytActns
				.find((JString lytNm -> LayoutAction lytAct) =>
					let (name = "``containingPckg``.``lytAct.ann.container``")
					name == cntrName) exists) {
				//add component at framework implementation level
				event.addComponent();
			}
		}
	}
}
