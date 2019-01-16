import ceylon.language.meta.declaration {
	FunctionDeclaration,
	NestableDeclaration,
	ClassDeclaration,
	Package,
	InterfaceDeclaration,
	ValueDeclaration,
	OpenClassOrInterfaceType,
	ClassOrInterfaceDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.action.awt {
	AwtLayoutAction
}
import it.feelburst.yayoi.model {
	Framework,
	Constructor,
	ComponentConstructor,
	ActionConstructor,
	lookAndFeelSettingConstr,
	Collector
}
import it.feelburst.yayoi.model.collection {
	Collection
}
import it.feelburst.yayoi.model.collection.awt {
	AwtCollection,
	AwtSystemTrayCollection
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.component.awt {
	AwtComponent
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.container.awt {
	AwtContainer,
	AwtLayout
}
import it.feelburst.yayoi.model.impl {
	LateValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.listener.awt {
	AwtListener
}
import it.feelburst.yayoi.model.setting {
	LookAndFeelSetting
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.model.window.awt {
	AwtWindow
}
import it.feelburst.yayoi.\iobject.listener.awt {
	DefaultWindowClosingAdapter
}

import java.awt {
	JComponent=Component,
	LayoutManager,
	JContainer=Container,
	MenuComponent,
	SystemTray,
	TrayIcon,
	Menu,
	Wndw=Window,
	Frame,
	Dialog
}
import java.lang {
	Types {
		classForType
	},
	Thread {
		currentThread
	}
}
import java.util {
	EventListener
}

import javax.swing {
	UIManager,
	SwingUtilities {
		invokeAndWait
	}
}

import org.springframework.beans.factory {
	NoSuchBeanDefinitionException
}
import org.springframework.context {
	ApplicationContext
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
shared abstract class AbstractAwtFramework(String name)
	extends Framework(name) {
	
	shared actual {Package*} packages = {
		`package it.feelburst.yayoi.\iobject.listener.awt`,
		`package it.feelburst.yayoi.\iobject.setting.awt`
	};
	
	shared actual void setLookAndFeel(ApplicationContext context) {
		try {
			value lookAndFeelName = context
				.getBean(classForType<LookAndFeelSetting>()).val;
			UIManager.setLookAndFeel(lookAndFeelName);
			log.info("Look and Feel '``lookAndFeelName``' set.");
		}
		catch (NoSuchBeanDefinitionException e) {
			log.info("No Look and Feel to set found.");
		}
	}
	
	shared actual void waitForWindowsToClose() =>
		awtThread.join();
	
	Thread awtThread {
		variable Thread? awtThread = null;
		invokeAndWait(() =>
			awtThread = currentThread());
		assert (exists thread = awtThread);
		return thread;
	}
	
	shared actual ClassDeclaration defaultWindowClosingListener() =>
			`class DefaultWindowClosingAdapter`;
	
}

shared object awtFramework extends AbstractAwtFramework("awt") {
	value constrs = map({
		//components
		`interface Component` -> awtCmpConstr,
		`interface Container` -> awtCntrConstr,
		`interface Collection` -> awtClctConstr,
		`interface Window` -> awtWndwConstr,
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

shared object awtCmpConstr satisfies ComponentConstructor {
	shared actual Component<JComponent|MenuComponent|SystemTray|TrayIcon> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(
			internalConstructor<JComponent|MenuComponent|SystemTray|TrayIcon>(
				name,
				decl,
				context)))
		AwtComponent(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
}

shared object awtCntrConstr satisfies ComponentConstructor {
	shared actual Container<JContainer> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JContainer>(name,decl,context)))
		AwtContainer(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
}

shared object awtClctConstr satisfies ComponentConstructor {
	
	function typeDecl(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) {
		try {
			assert (is OpenClassOrInterfaceType clctType = decl.openType);
			return clctType.declaration;
		}
		catch (Exception e) {
			return e;
		}
	}
	
	shared actual Collection<JContainer|Menu|SystemTray|TrayIcon> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) {
		value vl = LateValue(
			internalConstructor<JContainer|Menu|SystemTray|TrayIcon>(name,decl,context));
		if (is ClassOrInterfaceDeclaration clctTypeDecl = typeDecl(decl),
			clctTypeDecl == `class SystemTray`) {
			return AwtSystemTrayCollection(
				name,
				decl,
				vl,
				collecting(name,decl,context,`function Collector.collect`),
				collecting(name,decl,context,`function Collector.remove`),
				publishEvent(context));
		}
		return AwtCollection(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
	}
}

shared object awtWndwConstr satisfies ComponentConstructor {
	shared actual Window<Frame|Dialog|Wndw> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(
			internalConstructor<Frame|Dialog|Wndw>(name,decl,context)))
		AwtWindow(
			name,
			decl,
			vl,
			collecting(name,decl,context,`function Collector.collect`),
			collecting(name,decl,context,`function Collector.remove`),
			publishEvent(context));
	
}



shared object awtLytConstr satisfies ComponentConstructor {
	shared actual Layout<LayoutManager> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<LayoutManager>(name,decl,context)))
		AwtLayout(name,decl,vl,publishEvent(context));
}

shared object awtLstnrConstr satisfies ComponentConstructor {
	shared actual Listener<EventListener> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<EventListener>(name,decl,context)))
		AwtListener(name,decl,vl,publishEvent(context));
}

shared object awtLytActionConstr satisfies ActionConstructor {
	shared actual LayoutAction construct(
		String name,
		FunctionDeclaration decl,
		ApplicationContext context) =>
		AwtLayoutAction(name,decl,context);
}
