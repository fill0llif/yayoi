import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	NestableDeclaration,
	FunctionOrValueDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegistry,
	NameResolver,
	AnnotationReader
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	CenteredReaction,
	ExitOnCloseReaction,
	ParentReaction,
	SizeReaction,
	LocationReaction,
	WithLayoutReaction,
	CollectReaction,
	ListenableReaction
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
	WithLayoutAnnotation,
	LookAndFeelAnnotation,
	Marker,
	NamedAnnotation,
	CollectionAnnotation,
	CollectAnnotation,
	ListenableAnnotation,
	CollectValueAnnotation,
	RemoveValueAnnotation,
	lowestPrecedenceOrder
}
import it.feelburst.yayoi.model {
	Framework
}
import it.feelburst.yayoi.model.collection {
	Collection
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
import it.feelburst.yayoi.model.setting {
	CollectValueSetting,
	RemoveValueSetting,
	LookAndFeelSetting
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
					Collection<Object>|
					Window<Object>|
					Layout<Object>|
					Listener<Object>,
					ClassDeclaration|FunctionDeclaration|ValueDeclaration,
					ComponentAnnotation|
					ContainerAnnotation|
					CollectionAnnotation|
					WindowAnnotation|
					LayoutAnnotation|
					ListenerAnnotation,
					AnnotationConfigApplicationContext>(
					name,
					decl,
					ann,
					context);
				log.info("Component '``cmp``' registered.");
				// if reactor (e.g. have reactions)
				if (is Component<Object>|
					Container<Object,Object>|
					Collection<Object>|
					Window<Object> cmp) {
					registerReactions(cmp);
				}
			}
			// else if action
			else if (
				is FunctionDeclaration decl,
				exists ann = annotationChecker.action(decl)) {
				log.info("Registering Action '``decl``'...");
				value act = doRegister<
					LayoutAction,
					FunctionDeclaration,
					DoLayoutAnnotation>(
					name,
					decl,
					ann,
					context);
				log.info("Layout Action '``act.decl``' registered.");
			}
			// else if setting
			else if (exists ann = annotationChecker.setting(decl)) {
				log.info("Registering Setting '``decl``'...");
				value stng = doRegister<
					LookAndFeelSetting|CollectValueSetting|RemoveValueSetting,
					ClassDeclaration|FunctionDeclaration|ValueDeclaration,
					LookAndFeelAnnotation|CollectValueAnnotation|RemoveValueAnnotation>(
					name,
					decl,
					ann,
					context);
				if (is CollectValueSetting stng) {
					log.info(
						"Collect value setting '``stng.decl``' registered.");
				}
				else if (is RemoveValueSetting stng) {
					log.info(
						"Remove value setting '``stng.decl``' registered.");
				}
				else {
					log.info(
						"Look and Feel setting '``stng.decl``' registered.");
				}
			}
			else {
				log.warn(
					"Neither component nor action nor setting therefore no objects registered for '``decl``'.");
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
		Context context)
		given Type satisfies Object
		given Decl satisfies NestableDeclaration
		given Mrkr satisfies Annotation&Marker
		given Context satisfies ApplicationContext {
		value cmpDcl = marker.marked;
		value frmwrkActImplConstr = frameworkImpl
			.constructor<Type,Decl,Context>(cmpDcl);
		value cmp = frmwrkActImplConstr.construct(name,decl,context);
		beanFactory.registerSingleton(name, cmp);
		return cmp;
	}
	
	void registerReactions(
		Component<Object>|
		Container<Object,Object>|
		Collection<Object>|
		Window<Object> cmp) {
		if (exists ann = annotations(`SizeAnnotation`,cmp.decl)) {
			value sizeReaction = SizeReaction(cmp,ann,context);
			cmp.addReaction(sizeReaction);
			log.info("Size Reaction on Component '``cmp``' registered.");
			if (exists cntrdAnn = annotations(`CenteredAnnotation`,cmp.decl)) {
				cmp.addReaction(CenteredReaction(cmp,cntrdAnn,sizeReaction));
				log.info("Centered Reaction on Component '``cmp``' registered.");
			}
		}
		if (exists ann = annotations(`LocationAnnotation`,cmp.decl)) {
			cmp.addReaction(LocationReaction(cmp,ann));
			log.info("Location Reaction on Component '``cmp``' registered.");
		}
		if (exists ann = annotations(`WithLayoutAnnotation`,cmp.decl)) {
			if (is Container<Object,Object> cmp) {
				cmp.addReaction(WithLayoutReaction(cmp,ann,context));
				log.info("WithLayout Reaction on Component '``cmp``' registered.");
			}
			else {
				log.error(
					"WithLayout Reaction on Component '``cmp``' cannot be registered. " +
					"Component must be a Container.");
			}
		}
		if (exists ann = annotations(`ParentAnnotation`,cmp.decl)) {
			cmp.addReaction(ParentReaction(cmp,ann,context));
			log.info("Parent Reaction on Component '``cmp``' registered.");
		}
		if (exists ann = annotations(`ExitOnCloseAnnotation`,cmp.decl)) {
			if (is Window<Object> cmp) {
				cmp.addReaction(ExitOnCloseReaction(cmp,ann));
				log.info("ExitOnClose Reaction on Component '``cmp``' registered.");
				// if any window has exitOnClose the app cannot terminate properly
				// (e.g. every operation needed for the shutdown)
				// therefore a default window listener is needed
				value dfltWndwClsdCmp = frameworkImpl.defaultWindowClosingListener();
				value lstnrName = nameResolver
					.resolveUnbound(dfltWndwClsdCmp);
				value lstnrRoot = nameResolver
					.resolveRoot(dfltWndwClsdCmp);
				value windowEventAnn = ListenableAnnotation(
					lstnrName, 
					lstnrRoot, 
					lowestPrecedenceOrder.order);
				cmp.addReaction(ListenableReaction(cmp,windowEventAnn,context));
				log.info("WindowEvent Reaction on Component '``cmp``' registered.");
			}
			else {
				log.error(
					"WindowEvent Reaction on Component '``cmp``' cannot be registered. " +
					"Component must be a Window.");
			}
		}
		if (nonempty anns = annotations(`ListenableAnnotation`,cmp.decl)) {
			anns.each((ListenableAnnotation ann) {
				cmp.addReaction(ListenableReaction(cmp,ann,context));
				log.info("Listenable Reaction on Component '``cmp``' registered.");
			});
		}
		if (is Window<Object> cmp) {
			value ann = CollectAnnotation();
			cmp.addReaction(CollectReaction(cmp,ann,context));
			log.info("Collect Reaction on Window '``cmp``' registered.");
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
				value cmps = cmpsOrExs
				.narrow<
					Component<Object>|
					Container<Object,Object>|
					Collection<Object>|
					Window<Object>|
					Layout<Object>|
					Listener<Object>>();
				assert (is Type obj = decl.invoke([],*(cmps*.val)));
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