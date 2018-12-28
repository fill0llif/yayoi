import it.feelburst.yayoi.model {
	Declaration,
	Reactor,
	Value
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}
import it.feelburst.yayoi.model.collection {

	AbstractCollection
}

"A container that can be rendered on screen within a container
 and that can render its components using a layout manager"
shared interface Container<out Type,LayoutType>
	satisfies
		AbstractCollection&
		MutableWithLayout<LayoutType>&
		Declaration&
		Value<Type>&
		Reactor
	given Type satisfies Object
	given LayoutType satisfies Object {
	shared actual void accept(Visitor visitor) =>
		visitor.visitContainer(this);
}