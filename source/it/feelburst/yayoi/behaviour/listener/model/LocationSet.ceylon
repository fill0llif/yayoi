import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"An event that reports a location has been set on a component"
shared class LocationSet(
	shared AbstractComponent source,
	shared Integer x,
	shared Integer y) {}
