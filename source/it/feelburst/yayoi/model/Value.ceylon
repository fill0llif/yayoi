import ceylon.language.meta.model {
	Method
}
shared sealed interface Value<out Type> {
	"The value"
	shared formal Type val;
	"Execute an action on the value"
	shared ReturnType do<out ReturnType=Anything,in Arguments=Nothing>(
		Method<Type,ReturnType,Arguments> method)(Arguments args)
		given Arguments satisfies Anything[] =>
		method(val)(*args);
}
