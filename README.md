# Yayoi やよい
_Yayoi_ is a GUI annotation framework and provides/allows:
* Swing implementation of basic GUI components: _Component_, _Container_, _Collection_, _Window_, _Layout_ and _Listener_ (_Collection_ is a collection of components on which the user has no control over its layout, e.g. Swing menus);
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
	* Look and Feel is now a Setting;
	* **collectValue** and **removeValue** let the user decide how the internal collector should collect/remove the internal value. As of now:
		* JFrame|JDialog|JWindow collect/remove Container;
		* JFrame|JDialog collect/remove JMenuBar;
		* JMenuBar collect/remove JMenu;
		* JMenu collect/remove JMenuItem;
		* Container collect/remove Component;
		* Window collect/remove WindowListener;
		* AbstractButton collect/remove ActionListener;
* Abstract collections (Containers, Collections and Windows) are now mutable maps of components;
* abstract components deal now with mutable maps of listeners;
* automatically validating all the hierarchy whenever it is all invalidated;
* ordering components of **ordering** annotated abstract collections.

_Yayoi_ is written in [Ceylon](https://ceylon-lang.org) and is built on top of Spring

# Change Log

## 3.1.1 (2018-12-28)

**Added:**
- [#25 - Let the user define specific Settings](https://github.com/fill0llif/yayoi/issues/25);
- [#26 - Let the user define Collections](https://github.com/fill0llif/yayoi/issues/26);
- [#29 - Let the user define CollectValue and RemoveValue Settings to let a Component decides how the internal collector should collect/remove the internal value](https://github.com/fill0llif/yayoi/issues/29);
- [#30 - Let Collections be mutable maps and let Components access listeners using mutable maps may be useful](https://github.com/fill0llif/yayoi/issues/30);
- [#31 - Introduce Window validation lifecycle](https://github.com/fill0llif/yayoi/issues/31);
- [#35 - Let the user order components of abstract collections with `ordering` annotation on abstract collection](https://github.com/fill0llif/yayoi/issues/35);

**Changed:**
- [#23 - Value `do` method is useless](https://github.com/fill0llif/yayoi/issues/23);
- [#24 - Look and Feel may be more useful as a Setting](https://github.com/fill0llif/yayoi/issues/24);
- [#27 - Abstract adding Listeners to Components discarding specific Listener Reaction and introducing generic Listenable Reaction](https://github.com/fill0llif/yayoi/issues/27);
- [#28 - Window's collection of Components improvement](https://github.com/fill0llif/yayoi/issues/28);
- [#33 - WindowState improvement](https://github.com/fill0llif/yayoi/issues/33);
- [#34 - Change Swing implementation of centering a Window](https://github.com/fill0llif/yayoi/issues/34);

**Closed bugs/regressions:**
- [#7 - Components design flaw](https://github.com/fill0llif/yayoi/issues/7);
- [#20 - SwingLayoutAction failed to execute due to LateValue not being thread-safe](https://github.com/fill0llif/yayoi/issues/20);
- [#21 - SwingLayoutAction not running on AWT thread causes GroupLayout to raise an IllegalStateException](https://github.com/fill0llif/yayoi/issues/21);
- [#22 - Child component annotated with `parent` annotation cannot be resolved if package is different from the containing one](https://github.com/fill0llif/yayoi/issues/22);
- [#32 - Swing components implementations aren't covariant in its internal type](https://github.com/fill0llif/yayoi/issues/32);

**Regression:**
- [#7 - Components design flaw](https://github.com/fill0llif/yayoi/issues/7);

**Open:**
- [#19 - LateValue should use late annotation to retain the late value](https://github.com/fill0llif/yayoi/issues/19);

# Building

	ceylon compile --flat-classpath --fully-export-maven-dependencies
	
## Getting started

You just need to add this declaration to your Ceylon module:

```ceylon
import it.feelburst.yayoi "3.1.1";
```

