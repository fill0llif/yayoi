# Yayoi ‚â‚æ‚¢
_Yayoi_ is a GUI annotation framework and provides/allows:
* Swing implementation of basic GUI components: _Component_, _Container_, _Window_, _Layout_ and _Listener_;
* components are all lazily loaded;
* setting essential component properties, _Reactions_ (**size**, **location**, **centered**, etc.);
	* a reaction can depend on another one of the same component (e.g. **centered** depends on **size**);
* executing actions on multiple components, _Actions_ (as of now layout setting, **doLayout**, and Look and Feel setting, **setLookAndFeel**, are supported);
* registering listeners on components (as of now only _ActionListener_, **onActionPerformed**, and _WindowListener_, **onWindowEvent** are supported):
	* a default _WindowAdapter_ is already registered with lowest precedence (needed for application shutdown) if and only if a **exitOnClose** has been set on a window declaration;
* firing of Spring Event when basic component properties are set (on AWT Thread);
* enabling component construction using object, method and class notation (e.g. _ValueDeclaration_, _FunctionDeclaration_ and _ClassDeclaration_) within a package;
* autowiring of components constructed using class notation;
* defining a custom log writer;
	* a default log writer is already registered;
* visitor structure on component, container and window;
* layout construction on container declaration;
* autowiring support for components with **named** annotation on method parameters.

_Yayoi_ is written in [Ceylon](https://ceylon-lang.org) and is built on top of Spring

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

# Building

	ceylon compile --flat-classpath --fully-export-maven-dependencies
	
## Getting started

You just need to add this declaration to your Ceylon module:

```ceylon
import it.feelburst.yayoi "2.1.1";
```

