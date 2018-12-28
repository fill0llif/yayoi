import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.concurrent {
	Lock
}
shared final class LateValue<out Type>(Type construct())
	satisfies Value<Type> {
	value lock = Lock();
	variable value initialized = false;
	variable late Type internalVal;
	shared actual Type val {
		try (lock) {
			if (initialized) {
				return internalVal;
			}
			else {
				value val = construct();
				log.debug("Late value '``val else ""``' has been constructed.");
				internalVal = val;
				initialized = true;
				return internalVal;
			}
		}
	}
}
