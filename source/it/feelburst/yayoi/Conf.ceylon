import java.util.concurrent {
	ExecutorService,
	Executors {
		newCachedThreadPool
	}
}

import org.springframework.context.annotation {
	configuration,
	componentScan,
	bean,
	AnnotationConfigApplicationContext
}
import org.springframework.beans.factory.annotation {

	autowired
}
import org.springframework.context {

	ApplicationEventPublisher,
	ApplicationEvent
}
import java.lang {

	overloaded
}

configuration
componentScan({
	"it.feelburst.yayoi.behaviour.component",
	"it.feelburst.yayoi.behaviour.listener"
})
shared class Conf() {
	
	bean
	shared ApplicationEventPublisher eventPublisher(
		autowired AnnotationConfigApplicationContext context) =>
		object satisfies ApplicationEventPublisher {
			shared actual overloaded void publishEvent(ApplicationEvent event) =>
				context.publishEvent(event);
			shared actual overloaded void publishEvent(Object event) =>
				context.publishEvent(event);
		};
	
	bean
	shared ExecutorService executorService() =>
		newCachedThreadPool();
	
}