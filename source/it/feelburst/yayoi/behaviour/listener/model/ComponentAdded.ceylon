import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {

	AbstractContainer
}
"An event that reports a component has been added to a container"
shared class ComponentAdded(
	shared AbstractComponent component,
	shared AbstractContainer container,
	shared void addComponent()) {}
