import it.feelburst.yayoi.model {
	Value
}
shared final class LateValue<out Type>(Type construct())
	satisfies Value<Type> {
	variable value initialized = false;
	variable late Type internalVal;
	shared actual Type val {
		if (initialized) {
			return internalVal;
		}
		else {
			value val = construct();
			internalVal = val;
			initialized = true;
			return val;
		}
	}
}
