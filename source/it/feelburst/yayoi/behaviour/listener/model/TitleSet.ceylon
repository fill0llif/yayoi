import it.feelburst.yayoi.model.window {
	Window
}

import javax.swing {
	JFrame
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports a title has been set on a window"
shared class TitleSet(
	shared actual Window<JFrame> source,
	shared String title)
	extends ApplicationEvent(source) {}