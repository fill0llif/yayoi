import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container
}
import it.feelburst.yayoi.model.window {
	Window
}
"A reactor is a component (component, container or window only)
 with reactions"
see(
	`interface Component`,
	`interface Container`,
	`interface Window`,
	`interface Reaction`)
shared sealed interface Reactor {
	shared formal Reaction<Type>[] reactions<Type=Object>()
		given Type satisfies Object;
	shared formal void addReaction(Reaction<> reaction);
	shared formal void setReactions(Reaction<>[] reactions);
}