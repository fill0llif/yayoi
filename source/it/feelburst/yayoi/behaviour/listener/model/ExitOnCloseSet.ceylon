import it.feelburst.yayoi.model.window {
	Window
}

import javax.swing {
	JFrame
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports exit application on close has been set on a window"
shared class ExitOnCloseSet(shared actual Window<JFrame> source)
	extends ApplicationEvent(source) {}