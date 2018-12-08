"An object that can add or remove a component from its components"
shared sealed interface ComponentMutator {
	shared formal void addComponent(AbstractComponent component);
	shared formal AbstractComponent? removeComponent(String name);
}