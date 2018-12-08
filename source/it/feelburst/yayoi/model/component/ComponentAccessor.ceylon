"An object that has readonly access to its components"
shared sealed interface ComponentAccessor {
	shared formal AbstractComponent[] components;
	shared formal AbstractComponent? component(String name);
}