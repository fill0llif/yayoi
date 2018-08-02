import java.util.concurrent {
	ExecutorService,
	Executors {
		newCachedThreadPool
	}
}

import org.springframework.context.annotation {
	configuration,
	componentScan,
	bean
}

configuration
componentScan({
	"it.feelburst.yayoi.behaviour.component",
	"it.feelburst.yayoi.behaviour.listener"
})
shared class Conf() {
	
	bean
	shared ExecutorService executorService() =>
		newCachedThreadPool();
	
}