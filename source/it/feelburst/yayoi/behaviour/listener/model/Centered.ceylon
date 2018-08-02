import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports a component has been centered"
shared class Centered(shared actual AbstractComponent source)
	extends ApplicationEvent(source) {}