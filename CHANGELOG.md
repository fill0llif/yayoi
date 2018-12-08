# Yayoi やよい

# Change Log

## 2.1.1 (2018-12-08)

**Added:**
- [#4 - Type narrowing Reactions](https://github.com/fill0llif/yayoi/issues/4);
- [#9 - Visitor pattern applied on component, container and window may be useful](https://github.com/fill0llif/yayoi/issues/9);
- [#12 - Allowing undeclared value on components framework implementation construction may be useful](https://github.com/fill0llif/yayoi/issues/12);
- [#14 - Allowing constructing layout on container construction](https://github.com/fill0llif/yayoi/issues/14);
- [#15 - Add method parameters autowiring support for components](https://github.com/fill0llif/yayoi/issues/15);
- [#17 - Add support for Look and Feel setting](https://github.com/fill0llif/yayoi/issues/17);

**Changed:**
- [#5 - Object nullLayout is useless](https://github.com/fill0llif/yayoi/issues/5);
- [#8 - Title Reaction is useless](https://github.com/fill0llif/yayoi/issues/8);
- [#10 - Log configuration improvement](https://github.com/fill0llif/yayoi/issues/10);
- [#13 - Lock condition interface is useless](https://github.com/fill0llif/yayoi/issues/13);
- [#18 - User application 'run' method should run outside the AWT thread](https://github.com/fill0llif/yayoi/issues/18);

**Closed bugs/regressions:**
- [#1 - "NoSuchBeanDefinitionException: No bean named 'reactors' is defined" on startup](https://github.com/fill0llif/yayoi/issues/1);
- [#2 - "NoSuchBeanDefinitionException: No qualifying bean of type [org.springframework.context.ApplicationEventPublisher] is defined" on startup](https://github.com/fill0llif/yayoi/issues/2);
- [#3 - Misleading log listing GUI events as Actions](https://github.com/fill0llif/yayoi/issues/3);
- [#6 - Window components are early evaluated](https://github.com/fill0llif/yayoi/issues/6);
- [#7 - Components design error](https://github.com/fill0llif/yayoi/issues/7);
- [#11 - Components are not added to containers if not done with Layout action](https://github.com/fill0llif/yayoi/issues/11);
- [#16 - Logging object construction but that does not actually happen](https://github.com/fill0llif/yayoi/issues/16);

**Regression:**

**Open:**
- [#19 - LateValue should use late annotation to retain the late value](https://github.com/fill0llif/yayoi/issues/19);

## 1.0.0 (2018-08-03)

**Added:**
* Swing implementation of basic GUI components: Component, Container, Window, Layout and Listener;
* components are all lazily loaded;
* setting essential component properties, Reactions (size, location, centered, etc.);
	* a reaction can depend on another one of the same component (e.g centered depends on size);
* executing actions on multiple components, Actions (as of now layout setting, doLayout is supported);
* registering listeners on components (as of now only ActionListener, onActionPerformed, and WindowListener, onWindowEvent are supported):
	* a default WindowAdapter is already registered with lowest precedence (needed for application shutdown) if and only if a exitOnClose has been set on a window declaration;
* firing of Spring Event when basic component properties are set (on AWT Thread);
* enabling component construction using object, method and class notation (e.g. ValueDeclaration, FunctionDeclaration and ClassDeclaration) within a package;
* autowiring of components constructed using class notation;
* defining a custom log writer;
	* a default log writer is already registered.

**Changed:**

**Closed bugs/regressions:**

**Regression:**

**Open:**
