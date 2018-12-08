import it.feelburst.yayoi.model {
	Declaration,
	Reactor,
	Value
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}
"A component that can be rendered on screen within a container"
shared interface Component<out Type>
	satisfies AbstractComponent&Declaration&Value<Type>&Reactor
	given Type satisfies Object {
	shared actual void accept(Visitor visitor) =>
		visitor.visitComponent(this);
}