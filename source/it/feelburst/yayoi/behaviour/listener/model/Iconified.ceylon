import it.feelburst.yayoi.model.window {
	Window
}

import javax.swing {
	JFrame
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports a window has been iconified"
shared class Iconified(shared actual Window<JFrame> source)
	extends ApplicationEvent(source) {}