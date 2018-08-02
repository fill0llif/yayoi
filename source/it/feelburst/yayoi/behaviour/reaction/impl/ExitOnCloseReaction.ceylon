import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	ExitOnCloseAnnotation
}
import it.feelburst.yayoi.model.window {
	Window
}

import javax.swing {
	JFrame
}
"A reaction that sets exit application
 as a default window close operation"
shared class ExitOnCloseReaction(
	shared actual Window<JFrame> cmp,
	shared actual ExitOnCloseAnnotation ann)
	satisfies Reaction<Window<JFrame>> {
	shared actual void execute() {
		value setExitOnClose = ann.agentMdl(cmp);
		setExitOnClose();
		log.debug("ExitOnClose operation requested for Component '``cmp``'.");
	}
}