# Yayoi やよい
_Yayoi_ is a GUI annotation framework and provides/allows:
* Swing and AWT implementation of basic GUI components: _Component_, _Container_, _Collection_, _Window_, _Layout_ and _Listener_ (_Collection_ is a collection of components on which the user has no control over its layout, e.g. Swing menus);
* components are all lazily loaded;
* setting essential component properties, _Reactions_ (**size**, **location**, **centered**, etc.);
	* a reaction can depend on another one of the same component (e.g. **centered** depends on **size**);
* executing actions on multiple components, _Actions_ (as of now layout setting, **doLayout**);
* registering listeners on components with **listenable**:
	* a default _WindowAdapter_ is already registered with lowest precedence (needed for application shutdown) if and only if a **exitOnClose** has been set on a window declaration;
* firing of Spring Event when basic component properties are set (on AWT Thread);
* enabling component construction using object, method and class notation (e.g. _ValueDeclaration_, _FunctionDeclaration_ and _ClassDeclaration_) within a package;
* autowiring of components constructed using class notation;
* defining a custom log writer;
	* a default log writer is already registered;
* visitor structure on component, container, collection and window;
* layout construction on container declaration;
* autowiring support for components with **named** annotation on method parameters.
* defining _Settings_, top level class, method or object holding a reference to an object the user decide to use where he wants:
	* Look and Feel setting;
* defining Collectors for collecting internal values of components (using **collectable** and **collecting** annotation);
* default collectors:
	* JFrame|JDialog collect/remove JMenuBar;
	* Frame collect/remove MenuBar;
	* JFrame|JDialog|JWindow collect/remove Container;
	* Frame|Dialog|Window collect/remove Container;
	* SystemTray collect/remove TrayIcon;
	* TrayIcon collect/remove PopupMenu;
	* JMenuBar collect/remove JMenu;
	* MenuBar collect/remove Menu;
	* JMenu collect/remove JMenuItem;
	* Menu collect/remove MenuItem;
	* Container collect/remove Component;
	* Window collect/remove WindowListener;
	* AbstractButton collect/remove ActionListener;
	* MenuItem collect/remove ActionListener;
* abstract collections (Containers, Collections and Windows) are now mutable maps of components;
* abstract components deal now with mutable maps of listeners;
* automatically validating all the hierarchy whenever it is all invalidated;
* ordering components of **ordering** annotated abstract collections.

_Yayoi_ is written in [Ceylon](https://ceylon-lang.org) and is built on top of Spring

# Change Log

## 4.1.1 (2019-01-16)

**Added:**
- [#37 - Let the user define default framework and framework overrides with `framework` annotation](https://github.com/fill0llif/yayoi/issues/37);
- [#43 - Add AWT framework implementation](https://github.com/fill0llif/yayoi/issues/43);
- [#45 - Collections can be roots](https://github.com/fill0llif/yayoi/issues/45);

**Changed:**
- [#36 - Let the default log writer write on standard error if level is above info](https://github.com/fill0llif/yayoi/issues/36);
- [#37 - Let the user define default framework and framework overrides with `framework` annotation](https://github.com/fill0llif/yayoi/issues/37);
- [#41 - There is absolutely no need to use the metamodel to perform reactions](https://github.com/fill0llif/yayoi/issues/41);
- [#42 - Container doesn't need to specify generic layout type](https://github.com/fill0llif/yayoi/issues/42);

**Closed bugs/regressions:**
- [#38 - Application does not correctly shut down](https://github.com/fill0llif/yayoi/issues/38);
- [#39 - Collect and remove value settings replaced by Collectors](https://github.com/fill0llif/yayoi/issues/39);
- [#40 - Window's validation cycle may still not be defined when window is invalidated (causing NoSuchBeanDefinitionException)](https://github.com/fill0llif/yayoi/issues/40);
- [#44 - Assigning null layout when adding an unsuitable layout type on Swing/AWT container](https://github.com/fill0llif/yayoi/issues/44);

**Regression:**

**Open:**
- [#19 - LateValue should use late annotation to retain the late value](https://github.com/fill0llif/yayoi/issues/19);

# Building

	ceylon compile --flat-classpath --fully-export-maven-dependencies
	
## Getting started

You just need to add this declaration to your Ceylon module:

```ceylon
import it.feelburst.yayoi "4.1.1";
```

