import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	DisposeOnCloseAnnotation
}
import it.feelburst.yayoi.model.window {
	Window
}

"A reaction that disposes window
 as a default window close operation"
shared class DisposeOnCloseReaction(
	shared actual Window<Object> cmp,
	shared actual DisposeOnCloseAnnotation ann)
	satisfies Reaction<Window<Object>> {
	shared actual void execute() {
		cmp.setDisposeOnClose();
		log.debug("Reaction: DisposeOnClose operation requested for Window '``cmp``'.");
	}
}
