import it.feelburst.yayoi.model {

	Value
}
shared final class EagerValue<out Type>(
	shared actual Type val)
	satisfies Value<Type> {}
