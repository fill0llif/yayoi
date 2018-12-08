import it.feelburst.yayoi.model {
	Declaration,
	Named,
	Value
}
"A listener that listens to a component event"
shared interface Listener<out Type>
	satisfies Named&Declaration&Value<Type>
	given Type satisfies Object {}
