import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	TitleAnnotation
}
import it.feelburst.yayoi.model.window {
	Window
}

import javax.swing {
	JFrame
}
"A reaction that sets the title of a window"
shared class TitleReaction(
	shared actual Window<JFrame> cmp,
	shared actual TitleAnnotation ann)
	satisfies Reaction<Window<JFrame>> {
	shared actual void execute() {
		value setTitle = ann.agentMdl(cmp);
		setTitle(ann.val);
		log.debug("Title '``ann.val``' set requested for Component '``cmp``'.");
	}
}