import it.feelburst.yayoi.marker {
	Order
}
import it.feelburst.yayoi.model.window {

	Window
}
import it.feelburst.yayoi.model.container {

	Container,
	Layout
}
import it.feelburst.yayoi.model.component {

	Component
}
import it.feelburst.yayoi.model.listener {

	Listener
}
"A reaction arised from a component"
see(
	`interface Component`,
	`interface Container`,
	`interface Window`,
	`interface Listener`,
	`interface Layout`)
shared interface Reaction<out Cmpnt=Object> satisfies Order {
	"Component"
	shared formal Cmpnt cmp;
	"Reaction annotation"
	shared formal Annotation ann;
	"Reaction execution on the component"
	shared formal void execute();
	"Reaction execution order on the component"
	shared actual Integer order {
		assert (is Order a = ann);
		return a.order;
	}
}
