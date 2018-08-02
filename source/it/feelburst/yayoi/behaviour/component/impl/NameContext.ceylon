import ceylon.collection {
	MutableSet,
	TreeSet
}
import java.lang {
	Types {
		classForType
	}
}

import it.feelburst.yayoi.behaviour.component {
	Context
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.beans.factory.config {
	ConfigurableListableBeanFactory
}
import org.springframework.context {
	ApplicationContext
}
shared abstract class NameContext() satisfies Context<String> {
	
	autowired
	shared actual late ApplicationContext context;
	
	autowired
	shared actual late ConfigurableListableBeanFactory beanFactory;
	
	shared actual void register(String val) {
		if (context.containsBean(name)) {
			value cmps = context.getBean(name,classForType<MutableSet<String>>());
			assert (cmps.add(val));
		} else {
			MutableSet<String> cmps = TreeSet<String> {
				compare(String x, String y) => x <=> y;
				elements = {val};
			};
			beanFactory.registerSingleton(name, cmps);
		}
	}
}