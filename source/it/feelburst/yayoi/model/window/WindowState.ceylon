import it.feelburst.yayoi.model {
	Value
}
shared interface WindowState<out Type>
	satisfies Value<Type> {}
