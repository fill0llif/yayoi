import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	InterfaceDeclaration,
	Package,
	NestableDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.action.swing {
	SwingLayoutAction
}
import it.feelburst.yayoi.model {
	ActionConstructor,
	ComponentConstructor,
	Framework,
	SettingConstructor,
	Constructor
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
import it.feelburst.yayoi.model.container.swing {
	SwingContainer,
	SwingLayout
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
	CollectValueSetting,
	RemoveValueSetting,
	LookAndFeelSetting
}
import it.feelburst.yayoi.model.setting.impl {
	CollectValueSettingImpl,
	RemoveValueSettingImpl,
	LookAndFeelSettingImpl
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.model.window.swing {
	SwingWindow
}
import it.feelburst.yayoi.\iobject.listener.awt {
	DefaultWindowClosingAdapter
}
import it.feelburst.yayoi.\iobject.setting.swing {
	collectAwtContainer,
	collectAwtComponent,
	collectWindowListener,
	collectActionListener,
	removeAwtContainer,
	removeAwtComponent,
	removeWindowListener,
	removeActionListener
}

import java.awt {
	Wndw=Window,
	LayoutManager,
	JContainer=Container
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
	JDialog,
	JWindow,
	JFrame,
	JComponent,
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

shared object swingFramework extends Framework("swing") {
	value constrs = map({
		//components
		`interface Component` -> componentConstr,
		`interface Container` -> containerConstr,
		`interface Collection` -> collectionConstr,
		`interface Window` -> windowConstr,
		`interface Layout` -> layoutConstr,
		`interface Listener` -> listenerConstr,
		//actions
		`interface LayoutAction` -> layoutActionConstr,
		//settings
		`interface LookAndFeelSetting` -> lookAndFeelSettingConstr,
		`interface CollectValueSetting` -> collectValueSettingConstr,
		`interface RemoveValueSetting` -> removeValueSettingConstr
	});
	
	shared actual {Package*} packages = {
		`package it.feelburst.yayoi.\iobject.listener.awt`,
		`package it.feelburst.yayoi.\iobject.setting.swing`
	};
	
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
	
	
	shared actual {FunctionDeclaration*} defaultCollectValues() => {
		`function collectAwtContainer`,
		`function collectAwtComponent`,
		`function collectWindowListener`,
		`function collectActionListener`
	};
	
	shared actual {FunctionDeclaration*} defaultRemoveValues() => {
		`function removeAwtContainer`,
		`function removeAwtComponent`,
		`function removeWindowListener`,
		`function removeActionListener`
	};
	
}

shared object componentConstr satisfies ComponentConstructor {
	shared actual Component<JComponent> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JComponent>(name,decl,context)))
		SwingComponent(
			name,
			decl,
			vl,
			collectRemoveValue<CollectValueSetting>(name,context),
			collectRemoveValue<RemoveValueSetting>(name,context),
			publishEvent(context));
}

shared object containerConstr satisfies ComponentConstructor {
	shared actual Container<JContainer,Object> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JContainer>(name,decl,context)))
		SwingContainer<JContainer,Object>(
			name,
			decl,
			vl,
			collectRemoveValue<CollectValueSetting>(name,context),
			collectRemoveValue<RemoveValueSetting>(name,context),
			publishEvent(context));
}

shared object collectionConstr satisfies ComponentConstructor {
	shared actual Collection<JComponent> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JComponent>(name,decl,context)))
		SwingCollection<JComponent>(
			name,
			decl,
			vl,
			collectRemoveValue<CollectValueSetting>(name,context),
			collectRemoveValue<RemoveValueSetting>(name,context),
			publishEvent(context));
}

shared object windowConstr satisfies ComponentConstructor {
	shared actual Window<Wndw> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(
			internalConstructor<JFrame|JDialog|JWindow>(name,decl,context)))
		SwingWindow(
			name,
			decl,
			vl,
			collectRemoveValue<CollectValueSetting>(name,context),
			collectRemoveValue<RemoveValueSetting>(name,context),
			publishEvent(context));
}

shared object layoutConstr satisfies ComponentConstructor {
	shared actual Layout<LayoutManager> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<LayoutManager>(name,decl,context)))
		SwingLayout(name,decl,vl,publishEvent(context));
}

shared object listenerConstr satisfies ComponentConstructor {
	shared actual Listener<EventListener> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<EventListener>(name,decl,context)))
		AwtListener(name,decl,vl,publishEvent(context));
}

shared object layoutActionConstr satisfies ActionConstructor {
	shared actual LayoutAction construct(
		String name,
		FunctionDeclaration decl,
		ApplicationContext context) =>
		SwingLayoutAction(name,decl,context);
}

shared object lookAndFeelSettingConstr satisfies SettingConstructor {
	shared actual LookAndFeelSetting construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ApplicationContext context) {
		assert (is ValueDeclaration decl);
		return LookAndFeelSettingImpl(name,decl);
	}
}

shared object collectValueSettingConstr satisfies SettingConstructor {
	shared actual CollectValueSetting construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ApplicationContext context) {
		assert (is FunctionDeclaration decl);
		return CollectValueSettingImpl(name,decl);
	}
}

shared object removeValueSettingConstr satisfies SettingConstructor {
	shared actual RemoveValueSetting construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ApplicationContext context) {
		assert (is FunctionDeclaration decl);
		return RemoveValueSettingImpl(name,decl);
	}
}
