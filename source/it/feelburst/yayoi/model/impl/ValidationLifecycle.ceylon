import it.feelburst.yayoi.model.collection {
	Collection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent,
	Component
}
import it.feelburst.yayoi.model.concurrent {
	Lock
}
import it.feelburst.yayoi.model.container {
	Container
}
import it.feelburst.yayoi.model.visitor {
	Visitor,
	DepthFirstTraversalVisitor
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.lang {
	Runnable
}
shared final class ValidationLifecycle(
	Window<Object> window,
	void execute(Runnable runnable))
	satisfies Runnable {
	variable value running = false;
	value lock = Lock();
	value isValid = lock.newCondition();
	shared actual void run() {
		while (running) {
			try (lock) {
				while (running,valid) {
					isValid.await();
				}
				window.validate();
			}
		}
	}
	shared void start() {
		running = true;
		execute(this);
	}
	shared void stop() {
		running = false;
		invalidate();
	}
	shared void invalidate() {
		try (lock) {
			isValid.signal();
		}
	}
	Boolean valid {
		variable value valid = false;
		value validVstr = DepthFirstTraversalVisitor();
		validVstr.visitor = object satisfies Visitor {
			shared actual void visitComponent<Type>(Component<Type> visited) {
				stopIfValid(visited);
			}
			shared actual void visitCollection<Type>(Collection<Type> visited) {
				stopIfValid(visited);
			}
			shared actual void visitContainer<Type, LayoutType>(
				Container<Type,LayoutType> visited) {
				stopIfValid(visited);
			}
			shared actual void visitWindow<Type>(Window<Type> visited) {
				stopIfValid(visited);
			}
			void stopIfValid(AbstractComponent visited) {
				if (visited.valid) {
					validVstr.stop();
					valid = true;
				}
			}
		};
		window.accept(validVstr);
		return valid;
	}
}
