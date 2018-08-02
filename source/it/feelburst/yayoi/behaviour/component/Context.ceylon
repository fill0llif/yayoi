import ceylon.collection {
	MutableSet
}
import java.lang {
	Types {
		classForType
	}
}

import org.springframework.beans.factory.config {
	ConfigurableListableBeanFactory
}
import org.springframework.context {
	ApplicationContext
}
"General purpose in-memory context"
shared interface Context<Object> {
	"Context name"
	shared formal String name;
	shared formal ApplicationContext context;
	shared formal ConfigurableListableBeanFactory beanFactory;
	"Register object into the context"
	shared formal void register(Object val);
	"Context objects"
	shared default Object[] values() =>
		context
		.getBean(name,classForType<MutableSet<Object>>())
		.sequence();
}