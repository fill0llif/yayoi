import it.feelburst.yayoi.model.component {

	ComponentAccessor,
	ComponentMutator,
	AbstractComponent
}
import ceylon.collection {

	MutableMap,
	HashMap
}
shared class MutableContainer()
	satisfies ComponentAccessor&ComponentMutator{
	
	MutableMap<String,AbstractComponent> cmps = HashMap<String,AbstractComponent>();
	
	shared actual AbstractComponent? component(String name) =>
		cmps[name];
	
	shared actual AbstractComponent[] components =>
		cmps
		.items
		.sequence();
	
	shared actual void addComponent(AbstractComponent component) =>
		cmps[component.name] = component;
	
	shared actual AbstractComponent? removeComponent(String name) =>
		cmps.remove(name);
	
}