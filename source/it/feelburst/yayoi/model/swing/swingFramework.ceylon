import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	InterfaceDeclaration,
	NestableDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.model {
	ComponentConstructor,
	Constructor,
	lookAndFeelSettingConstr,
	Collector
}
import it.feelburst.yayoi.model.awt {
	awtCntrConstr,
	awtLytConstr,
	awtLstnrConstr,
	awtLytActionConstr,
	AbstractAwtFramework
}
import it.feelburst.yayoi.model.collection {
	Collection
}
import it.feelburst.yayoi.model.collection.swing {
	SwingCollection
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.component.swing {
	SwingComponent
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.impl {
	LateValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.setting {
	LookAndFeelSetting
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.model.window.swing {
	SwingWindow
}

import javax.swing {
	JDialog,
	JWindow,
	JFrame,
	JComponent
}

import org.springframework.context {
	ApplicationContext
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}

shared object swingFramework extends AbstractAwtFramework("swing") {
	value constrs = map({
		//components
		`interface Component` -> swingCmpConstr,
		`interface Container` -> awtCntrConstr,
		`interface Collection` -> swingClctConstr,
		`interface Window` -> swingWndwConstr,
		`interface Layout` -> awtLytConstr,
		`interface Listener` -> awtLstnrConstr,
		//actions
		`interface LayoutAction` -> awtLytActionConstr,
		//settings
		`interface LookAndFeelSetting` -> lookAndFeelSettingConstr
	});
	
	shared actual ConstructorType constructor<
		Type,
		Decl,
		Context,
		ConstructorType=Constructor<Type,Decl,Context>>(
		InterfaceDeclaration constrIntr)
		given Type satisfies Object
		given Decl satisfies NestableDeclaration
		given Context satisfies ApplicationContext
		given ConstructorType satisfies Constructor<Type,Decl,Context> {
		if (is ConstructorType cnstr = constrs[constrIntr]) {
			return cnstr;
		}
		else {
			value message = "Component/Action/Setting constructor not found.";
			log.error(message);
			throw Exception(message);
		}
	}
}

shared object swingCmpConstr satisfies ComponentConstructor {
	shared actual Component<JComponent> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JComponent>(name,decl,context)))
		SwingComponent(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
}

shared object swingClctConstr satisfies ComponentConstructor {
	shared actual Collection<JComponent> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JComponent>(name,decl,context)))
		SwingCollection(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
}

shared object swingWndwConstr satisfies ComponentConstructor {
	shared actual Window<JFrame|JDialog|JWindow> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(
			internalConstructor<JFrame|JDialog|JWindow>(name,decl,context)))
		SwingWindow(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
}
