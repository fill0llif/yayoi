import it.feelburst.yayoi.behaviour.listener.model {
	IndependentDoneExecuting,
	SizeSet,
	Centered,
	LocationSet,
	ComponentCollected,
	ComponentRemoved,
	RootSetup,
	RootInvalidated,
	Closed,
	Packed,
	Iconified,
	Maximized,
	Restored
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Independent
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	SizeReaction
}
import it.feelburst.yayoi.model {
	Reactor
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.impl {
	ValidationLifecycle
}

import java.lang {
	Types {
		classForType
	}
}
import java.util.concurrent {
	ExecutorService
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.beans.factory.config {
	ConfigurableListableBeanFactory
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
import it.feelburst.yayoi.model.window {

	Window
}
component
shared class ComponentListener() {
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ConfigurableListableBeanFactory beanFactory;
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	autowired
	late ExecutorService executor;
	
	eventListener
	shared void handleSizeSet(SizeSet event) {
		eventPublisher.publishEvent(IndependentDoneExecuting(
			event.source,
			(Reaction<Object> rctn) =>
				rctn is SizeReaction));
	}
	
	eventListener
	shared void handleCentered(Centered event) {
		value source = event.source;
		eventPublisher.publishEvent(LocationSet(source,source.x,source.y));
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
	
	eventListener
	shared void handleComponentCollected(ComponentCollected event) {
		event.collected.invalidate();
	}
	
	eventListener
	shared void handleComponentRemoved(ComponentRemoved event) {
		event.collected.invalidate();
	}
	
	eventListener
	shared void handlePacked(Packed event) {
		event.source.invalidate();
	}
	
	eventListener
	shared void handleIconified(Iconified event) {
		event.source.invalidate();
	}
	
	eventListener
	shared void handleMaximized(Maximized event) {
		event.source.invalidate();
	}
	
	eventListener
	shared void handleRestored(Restored event) {
		event.source.invalidate();
	}
	
	eventListener
	shared void handleWindowConstructed(RootSetup event) {
		if (is Window<Object> root = event.root) {
			value wndwVldtLfcycl = ValidationLifecycle(
				root,
				executor.execute);
			beanFactory.registerSingleton(
				root.name + ".lifecycle", 
				wndwVldtLfcycl);
			wndwVldtLfcycl.start();
		}
	}
	
	eventListener
	shared void handleRootInvalidated(RootInvalidated event) {
		if (is Window<Object> root = event.root) {
			value rootName = root.name + ".lifecycle";
			if (context.containsBean(rootName)) {
				value wndwVldtLfcycl = context.getBean(
					rootName,
					classForType<ValidationLifecycle>());
				wndwVldtLfcycl.invalidate();
			}
		}
	}
	
	eventListener
	shared void handleClosed(Closed event) {
		value wndwVldtLfcycl = context.getBean(
			event.source.name + ".lifecycle",
			classForType<ValidationLifecycle>());
		wndwVldtLfcycl.stop();
	}
	
}
