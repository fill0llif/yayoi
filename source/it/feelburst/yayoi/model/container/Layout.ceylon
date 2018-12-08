import it.feelburst.yayoi.model {
	Named,
	Declaration,
	Value
}
"A layout that defines how the components of a container are
 rendered on screen"
shared interface Layout<out Type>
	satisfies Named&Declaration&Value<Type>
	given Type satisfies Object {}
