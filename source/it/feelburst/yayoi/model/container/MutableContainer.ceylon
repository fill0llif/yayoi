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
		.sort((AbstractComponent x, AbstractComponent y) =>
			x.name <=> y.name)
		.sequence();
	
	shared actual void addComponent(AbstractComponent component) =>
		cmps[component.name] = component;
	
	shared actual void removeComponent(String name) =>
		cmps.remove(name);
	
}