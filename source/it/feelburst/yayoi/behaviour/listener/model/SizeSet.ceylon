import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"An event that reports a size has been set on a component"
shared class SizeSet(
	shared AbstractComponent source,
	shared Integer width,
	shared Integer height) {}
