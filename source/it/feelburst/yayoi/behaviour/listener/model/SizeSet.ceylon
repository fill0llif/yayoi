import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports a size has been set on a component"
shared class SizeSet(
	shared actual AbstractComponent source,
	shared Integer width,
	shared Integer height)
	extends ApplicationEvent(source) {}