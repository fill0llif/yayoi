import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	InterfaceDeclaration,
	NestableDeclaration,
	FunctionOrValueDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LookAndFeelAction,
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegistry,
	NameResolver,
	AnnotationReader
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	CenteredReaction,
	OnActionPerformedReaction,
	ExitOnCloseReaction,
	ParentReaction,
	SizeReaction,
	LocationReaction,
	WithLayoutReaction,
	WindowEventReaction
}
import it.feelburst.yayoi.marker {
	ContainerAnnotation,
	ComponentAnnotation,
	WindowAnnotation,
	ListenerAnnotation,
	DoLayoutAnnotation,
	CenteredAnnotation,
	LocationAnnotation,
	ParentAnnotation,
	ExitOnCloseAnnotation,
	SizeAnnotation,
	LayoutAnnotation,
	OnActionPerformedAnnotation,
	WithLayoutAnnotation,
	WindowEventAnnotation,
	lowestPrecedenceOrder,
	SetLookAndFeelAnnotation,
	Marker,
	NamedAnnotation
}
import it.feelburst.yayoi.model {
	Framework,
	Constructor
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.beans.factory.config {
	ConfigurableListableBeanFactory
}
import org.springframework.context {
	ApplicationContext
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
import org.springframework.stereotype {
	component
}

component
shared class ComponentRegistryImpl() satisfies ComponentRegistry {
	
	autowired
	shared actual late AnnotationReader annotationChecker;
	
	autowired
	shared actual late NameResolver nameResolver;
	
	autowired
	late Framework frameworkImpl;
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ConfigurableListableBeanFactory beanFactory;
	
	autowired
	late ReactorContext reactorContext;
	
	autowired
	late ActionContext actionContext;
	
	shared actual void register(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) {
		log.info("Resolving name for '``decl``'...");
		value name = nameResolver.resolve(decl);
		if (is String name) {
			// if component
			if (exists ann = annotationChecker.component(decl)) {
				log.info("Registering Component '``decl``'...");
				value cmp = doRegister<
					Component<Object>|
					Container<Object,Object>|
					Window<Object>|
					Layout<Object>|
					Listener<Object>,
					ClassDeclaration|FunctionDeclaration|ValueDeclaration,
					ComponentAnnotation|
					ContainerAnnotation|
					WindowAnnotation|
					LayoutAnnotation|
					ListenerAnnotation,
					AnnotationConfigApplicationContext>(
					name,decl,ann,frameworkImpl.componentConstructor,context);
				log.info("Component '``cmp``' registered.");
				// if reactor (e.g. have reactions)
				if (is Component<Object>|
					Container<Object,Object>|
					Window<Object> cmp) {
					reactorContext.register(cmp.name);
					log.info("Reactor '``cmp``' registered.");
					registerReactions(cmp);
				}
			}
			// else if action
			else if (
				is FunctionDeclaration decl,
				exists ann = annotationChecker.action(decl)) {
				log.info("Registering Action '``decl``'...");
				value act = doRegister<
					LayoutAction|LookAndFeelAction,
					FunctionDeclaration,
					DoLayoutAnnotation|SetLookAndFeelAnnotation>(
					name,decl,ann,frameworkImpl.actionConstructor,context);
				actionContext.register(act.name);
				log.info("Action '``act``' registered.");
			}
			else {
				log.warn(
					"Neither component nor action therefore no objects registered for '``decl``'.");
			}
		}
		else {
			log.error(
				"Component or Action cannot be registered due to the following error: " +
				name.message);
		}
	}
	
	Type doRegister<Type,Decl,Mrkr,Context=ApplicationContext>(
		String name,
		Decl decl,
		Mrkr marker,
		Constructor<Type,Decl,Context> constructor(InterfaceDeclaration cmpDecl),
		Context context)
		given Type satisfies Object
		given Decl satisfies NestableDeclaration
		given Mrkr satisfies Annotation&Marker
		given Context satisfies ApplicationContext {
		value cmpDcl = marker.marked;
		value frmwrkActImplConstr = constructor(cmpDcl);
		value cmp = frmwrkActImplConstr.construct(name,decl,context);
		beanFactory.registerSingleton(name, cmp);
		return cmp;
	}
	
	void registerReactions(
		Component<Object>|
		Container<Object,Object>|
		Window<Object> cmp) {
		if (exists ann = annotations(`SizeAnnotation`,cmp.decl)) {
			value sizeReaction = SizeReaction(cmp,ann,context);
			cmp.addReaction(sizeReaction);
			log.info("Size Reaction on Component'``cmp``' registered.");
			if (exists cntrdAnn = annotations(`CenteredAnnotation`,cmp.decl)) {
				cmp.addReaction(CenteredReaction(cmp,cntrdAnn,sizeReaction));
				log.info("Centered Reaction on Component'``cmp``' registered.");
			}
		}
		if (exists ann = annotations(`LocationAnnotation`,cmp.decl)) {
			cmp.addReaction(LocationReaction(cmp,ann));
			log.info("Location Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`WithLayoutAnnotation`,cmp.decl)) {
			assert (is Container<Object,Object> cmp);
			cmp.addReaction(WithLayoutReaction(cmp,ann,context));
			log.info("WithLayout Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`ParentAnnotation`,cmp.decl)) {
			cmp.addReaction(ParentReaction(cmp,ann,context));
			log.info("Parent Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`ExitOnCloseAnnotation`,cmp.decl)) {
			assert (is Window<Object> cmp);
			cmp.addReaction(ExitOnCloseReaction(cmp,ann));
			log.info("ExitOnClose Reaction on Component'``cmp``' registered.");
			// if any window has exitOnClose the app cannot terminate properly
			// (e.g. every operation needed for the shutdown)
			// therefore a default window listener is needed
			value dfltWndwClsdCmp = frameworkImpl.defaultWindowClosingListener();
			value lstnrName = nameResolver
				.resolveUnbound(dfltWndwClsdCmp);
			value lstnrRoot = nameResolver
				.resolveRoot(dfltWndwClsdCmp);
			value windowEventAnn = WindowEventAnnotation(
				lstnrName, 
				lstnrRoot, 
				lowestPrecedenceOrder.order);
			register(dfltWndwClsdCmp);
			cmp.addReaction(WindowEventReaction(cmp,windowEventAnn,context));
			log.info("WindowEvent Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`OnActionPerformedAnnotation`,cmp.decl)) {
			cmp.addReaction(OnActionPerformedReaction(cmp,ann,context));
			log.info("OnActionPerformed Reaction on Component'``cmp``' registered.");
		}
	}
	
	shared actual <Type|Exception>() autowired<Type>(
		String name,
		FunctionDeclaration decl) =>
		let (cmpsOrExs = decl.parameterDeclarations
		.collect((FunctionOrValueDeclaration prmtrDecl) =>
			if (is ValueDeclaration prmtrDecl) then
				if (exists prmtrNmd = annotations(`NamedAnnotation`,prmtrDecl)) then
					let (prmtrName = nameResolver.resolveNamed(decl, prmtrNmd))
					if (prmtrName != name) then
						if (context.containsBean(prmtrName)) then
							context.getBean(prmtrName)
						else
							Exception(
								"No component named '``prmtrName``' to autowire into " +
								"declaration '``prmtrDecl``' of declaration '``decl``' " +
								"has been found.")
					else
						Exception(
							"Cannot autowire component '``prmtrName``' into declaration " +
							"'``prmtrDecl``' of declaration '``decl``'. They are the same " +
							"object! A component cannot autowire itself!")
				else
					Exception(
						"No named annotation found on declaration " +
						"'``prmtrDecl``' of declaration '``decl``'.")
			else
				Exception(
					"Parameter declaration '``prmtrDecl``' of declaration " +
					"'``decl``' must be a value declaration.")))
		
		let (exs = cmpsOrExs.narrow<Exception>())
		if (exs.empty) then
			(() {
				value cmps = cmpsOrExs.narrow<
					Component<Object>|
					Container<Object,Object>|
					Window<Object>|
					Layout<Object>|
					Listener<Object>>();
				log.debug("Invoking autowired internal component construction...");
				value val = decl.invoke([],*(cmps*.val));
				log.debug("Internal component ``val else "null"``");
				assert (is Type obj = val);
				return obj;
			})
		else
			let (throwing = (() {
				return Exception(
					"Cannot autowire parameter declarations of declaration "+
					"'``decl``' due to the following errors: ``exs*.message``.");
			}))
			throwing;
			
}