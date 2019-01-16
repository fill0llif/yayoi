import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	ExitOnCloseAnnotation
}
import it.feelburst.yayoi.model.window {
	Window
}

"A reaction that sets exit application
 as a default window close operation"
shared class ExitOnCloseReaction(
	shared actual Window<Object> cmp,
	shared actual ExitOnCloseAnnotation ann)
	satisfies Reaction<Window<Object>> {
	shared actual void execute() {
		cmp.setExitOnClose();
		log.debug("Reaction: ExitOnClose operation requested for Window '``cmp``'.");
	}
}
