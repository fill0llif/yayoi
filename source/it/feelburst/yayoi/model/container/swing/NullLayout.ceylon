import java.awt {
	LayoutManager,
	Component,
	Container,
	Dimension
}
shared object nullLayout satisfies LayoutManager {
	shared actual void layoutContainer(Container? parent) {}
	shared actual Dimension minimumLayoutSize(Container? parent) => Dimension();
	shared actual Dimension preferredLayoutSize(Container? parent) => Dimension();
	shared actual void addLayoutComponent(String? name, Component? comp) {}
	shared actual void removeLayoutComponent(Component? comp) {}
}