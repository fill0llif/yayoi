# Yayoi
_Yayoi_ is a GUI annotation framework and provides/allows:
* Swing/Awt implementation of basic GUI components: _Component_, _Container_, _Window_, _Layout_ and _Listener_;
* components are all lazily loaded;
* setting essential component properties, _Reactions_ (**size**, **location**, **centered**, etc.);
	* a reaction can depend on another one of the same component (e.g **centered** depends on **size**);
* executing actions on multiple components, _Actions_ (as of now only layout setting, **doLayout**, is supported);
* registering listeners on components (as of now only _ActionListener_, **onActionPerformed**, and _WindowListener_, **onWindowEvent** are supported):
	* a default _WindowAdapter_ is already registered with lowest precedence (needed for application shutdown) if and only if a ***exitOnClose** has been set on a window declaration;
* firing of Spring Event when basic component properties are set (on AWT Thread);
* enabling component construction using object, method and class notation (e.g. _ValueDeclaration_, _FunctionDeclaration_ and _ClassDeclaration_) within a package;
* autowiring of components constructed using class notation;
* defining a custom log writer;
	* a default log writer is already registered.

_Yayoi_ is written in [Ceylon](https://ceylon-lang.org) and is built on top of Spring

# Building

	ceylon compile --flat-classpath --fully-export-maven-dependencies
	
## Getting started

You just need to add this declaration to your Ceylon module:

```ceylon
import it.feelburst.yayoi "1.0.0";
```

