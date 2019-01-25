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
* autowiring support for components with **named** and for any other beans with **autowired** or **qualifier** annotations on method parameters;
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
	* JComponent collect/remove JPopupMenu;
	* Component collect/remove MouseListener;
	* Component collect/remove MouseMotionListener;
* abstract collections (Containers, Collections and Windows) are now mutable maps of components;
* abstract components deal now with mutable maps of listeners;
* automatically validating all the hierarchy whenever it is all invalidated;
* ordering components of **ordering** annotated abstract collections;
* scanning of Spring components contained in Yayoi packages.

_Yayoi_ is written in [Ceylon](https://ceylon-lang.org) and is built on top of Spring

# Change Log

## 5.1.0 (2019-01-25)

**Added:**
- [#46 - Add DisposeOnClose and HideOnClose reactions](https://github.com/fill0llif/yayoi/issues/46);
- [#47 - Add Swing ComponentPopupMenu, MouseListener, MouseMotionListener collectors support](https://github.com/fill0llif/yayoi/issues/47);
- [#48 - Add method autowiring support for non-Component beans using `autowired` or `qualifier`](https://github.com/fill0llif/yayoi/issues/48);
- [#49 - Add Spring scan of Yayoi packages](https://github.com/fill0llif/yayoi/issues/49);

**Changed:**

**Closed bugs/regressions:**

**Regression:**

**Open:**
- [#19 - LateValue should use late annotation to retain the late value](https://github.com/fill0llif/yayoi/issues/19);

# Building

	ceylon compile --flat-classpath --fully-export-maven-dependencies
	
## Getting started

You just need to add this declaration to your Ceylon module:

```ceylon
import it.feelburst.yayoi "5.1.0";
```

