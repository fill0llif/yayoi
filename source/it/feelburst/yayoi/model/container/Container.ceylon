import it.feelburst.yayoi.model {
	Declaration,
	Reactor,
	Value
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}

"A container that can be rendered on screen within a container
 and that can render its components using a layout manager"
shared interface Container<out Type>
	satisfies
		AbstractCollection&
		Declaration&
		Value<Type>&
		Reactor
	given Type satisfies Object {
	shared formal variable Layout<Object>? layout;
	shared default actual void accept(Visitor visitor) =>
		visitor.visitContainer(this);
}
