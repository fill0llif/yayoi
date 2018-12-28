import it.feelburst.yayoi.model {
	Value,
	Reactor,
	Declaration
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}
"A collection that can be rendered on screen within a container/collection
 and that can render its components without control on the layout"
shared interface Collection<out Type>
	satisfies
		AbstractCollection&
		Declaration&
		Value<Type>&
		Reactor
	given Type satisfies Object {
	shared actual void accept(Visitor visitor) =>
		visitor.visitCollection(this);
}
