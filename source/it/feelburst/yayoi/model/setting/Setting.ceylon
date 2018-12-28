import it.feelburst.yayoi.model {
	Declaration,
	Named,
	Value
}
"A setting holds a reference to an object"
shared interface Setting<out Type>
	satisfies
		Named&
		Value<Type>&
		Declaration {
	"Setting annotation"
	shared formal Annotation ann;
	
	shared actual String string =>
		name;
}
