import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	HideOnCloseAnnotation
}
import it.feelburst.yayoi.model.window {
	Window
}

"A reaction that hides window
 as a default window close operation"
shared class HideOnCloseReaction(
	shared actual Window<Object> cmp,
	shared actual HideOnCloseAnnotation ann)
	satisfies Reaction<Window<Object>> {
	shared actual void execute() {
		cmp.setHideOnClose();
		log.debug("Reaction: HideOnClose operation requested for Window '``cmp``'.");
	}
}
