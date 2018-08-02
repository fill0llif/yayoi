"An object that can add or remove a component from its components"
shared interface ComponentMutator {
	shared formal void addComponent(AbstractComponent component);
	shared formal void removeComponent(String name);
}