import ceylon.collection {
	HashMap
}
import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	NestableDeclaration,
	FunctionOrValueDeclaration,
	OpenClassType,
	OpenInterfaceType
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
	ListenableReaction,
	DisposeOnCloseReaction,
	HideOnCloseReaction
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
	lowestPrecedenceOrder,
	FrameworkAnnotation,
	DisposeOnCloseAnnotation,
	HideOnCloseAnnotation
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
	LookAndFeelSetting
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.lang {
	Types {
		classForDeclaration
	}
}

import org.springframework.beans.factory.annotation {
	autowired,
	Autowired,
	Qualifier,
	qualifier
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
	late Framework framework;
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ConfigurableListableBeanFactory beanFactory;
	
	value frmwrkCache = HashMap<ValueDeclaration,Framework>();
	
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
					Container<Object>|
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
					Container<Object>|
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
					LookAndFeelSetting,
					ClassDeclaration|FunctionDeclaration|ValueDeclaration,
					LookAndFeelAnnotation>(
					name,
					decl,
					ann,
					context);
				log.info("Look and Feel setting '``stng.decl``' registered.");
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
		value framework = frmwrk(decl);
		value frmwrkActImplConstr = framework
			.constructor<Type,Decl,Context>(cmpDcl);
		value cmp = frmwrkActImplConstr.construct(name,decl,context);
		beanFactory.registerSingleton(name, cmp);
		return cmp;
	}
	
	Framework frmwrk(NestableDeclaration decl) {
		if (is ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
			exists ann = annotations(`FrameworkAnnotation`,decl)) {
			if (exists frmwrk = frmwrkCache[ann.framework]) {
				log.debug("Framework implementation '``decl``' override found.");
				return frmwrk;
			}
			else {
				try {
					value frmwrk = ann.framework.apply<Framework>().get();
					frmwrkCache[ann.framework] = frmwrk;
					log.debug("Framework implementation '``decl``' override found.");
					return frmwrk;
				}
				catch (Exception e) {
					value message =
						"Cannot retrieve framework for declaration '``decl``' " +
						"due to the following error: ``e.message``.";
					log.error(message);
					throw Exception(message);
				}
			}
		}
		else {
			return this.framework;
		}
	}
	
	void registerReactions(
		Component<Object>|
		Container<Object>|
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
			if (is Container<Object> cmp) {
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
				value dfltWndwClsdCmp = framework.defaultWindowClosingListener();
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
					"ExitOnClose Reaction on Component '``cmp``' cannot be registered. " +
					"Component must be a Window.");
			}
		}
		if (exists ann = annotations(`DisposeOnCloseAnnotation`,cmp.decl)) {
			if (is Window<Object> cmp) {
				cmp.addReaction(DisposeOnCloseReaction(cmp,ann));
				log.info("DisposeOnClose Reaction on Component '``cmp``' registered.");
			}
			else {
				log.error(
					"DisposeOnClose Reaction on Component '``cmp``' cannot be registered. " +
					"Component must be a Window.");
			}
		}
		if (exists ann = annotations(`HideOnCloseAnnotation`,cmp.decl)) {
			if (is Window<Object> cmp) {
				cmp.addReaction(HideOnCloseReaction(cmp,ann));
				log.info("HideOnClose Reaction on Component '``cmp``' registered.");
			}
			else {
				log.error(
					"HideOnClose Reaction on Component '``cmp``' cannot be registered. " +
					"Component must be a Window.");
			}
		}
		if (nonempty anns = annotations(`ListenableAnnotation`,cmp.decl)) {
			anns.each((ListenableAnnotation ann) {
				cmp.addReaction(ListenableReaction(cmp,ann,context));
				log.info("Listenable Reaction on Component '``cmp``' registered.");
			});
		}
		if (is Window<Object>|Collection<Object> cmp,
			exists root = cmp.root, root == cmp) {
			value ann = CollectAnnotation();
			cmp.addReaction(CollectReaction(cmp,ann,context));
			log.info("Collect Reaction on Window '``cmp``' registered.");
		}
	}
	
	function getClassOrInterfaceType(
		FunctionDeclaration|ValueDeclaration decl) {
		try {
			switch (type = decl.openType)
			case (is OpenClassType|OpenInterfaceType) {
				return type;
			}
			else {
				return Exception(
					"Type of declararion '``decl``' must be a class or an interface.");
			}
		}
		catch (Exception e) {
			return e;
		}
	}
	
	function sameType(FunctionDeclaration decl,ValueDeclaration prmtrDecl) {
		value mthdType = getClassOrInterfaceType(decl);
		value prmtrType = getClassOrInterfaceType(prmtrDecl);
		if (is OpenClassType|OpenInterfaceType mthdType) {
			if (is OpenClassType|OpenInterfaceType prmtrType) {
				return mthdType.declaration == prmtrType.declaration;
			}
			else {
				return prmtrType;
			}
		}
		else {
			return mthdType;
		}
	}
	
	
	function getBeanByType(ValueDeclaration prmtrDecl) {
		try {
			value prmtrType = getClassOrInterfaceType(prmtrDecl);
			if (is OpenClassType|OpenInterfaceType prmtrType) {
				return context.getBean(classForDeclaration(prmtrType.declaration));
			}
			else {
				return prmtrType;
			}
		}
		catch (Exception e) {
			return e;
		}
	}
	
	function getBeanByName(
		String name,
		FunctionDeclaration decl,
		String prmtrName,
		ValueDeclaration prmtrDecl) =>
		// you cannot autowire the same object
		if (prmtrName != name) then
			if (context.containsBean(prmtrName)) then
				context.getBean(prmtrName)
			else
				Exception(
					"No object named '``prmtrName``' to autowire into " +
					"declaration '``prmtrDecl``' of declaration '``decl``' " +
					"has been found.")
		else
			Exception(
				"Cannot autowire object '``prmtrName``' into declaration " +
				"'``prmtrDecl``' of declaration '``decl``'. They are the same " +
				"object! An object cannot autowire itself!");
		
	
	shared actual <Type|Exception>() autowired<Type>(
		String name,
		FunctionDeclaration decl) =>
		let (cmpsOrObjsOrExs = decl.parameterDeclarations
		.collect((FunctionOrValueDeclaration prmtrDecl) =>
			//parameter must be a value
			if (is ValueDeclaration prmtrDecl) then
				//named for components
				if (exists prmtrNmd = annotations(`NamedAnnotation`,prmtrDecl)) then
					let (prmtrName = nameResolver.resolveNamed(decl, prmtrNmd))
					getBeanByName(name,decl,prmtrName,prmtrDecl)
				//autowire any other bean by name
				else if (nonempty qlfrAnns = prmtrDecl.annotations<Qualifier>()) then
					let (prmtrName = qlfrAnns.first.\ivalue())
					getBeanByName(name,decl,prmtrName,prmtrDecl)
				//autowired any other bean by type
				else if (prmtrDecl.annotated<Autowired>()) then
					let (stap = sameType(decl,prmtrDecl))
					if (is Boolean stap) then
						//autowire by type
						if (!stap) then
							let (bbt = getBeanByType(prmtrDecl))
							if (is Exception bbt) then
								Exception(
									"Cannot autowire object into declaration " +
									"'``prmtrDecl``' of declaration '``decl``' due to the " +
									"following error: ``bbt.message``.")
							else
								bbt
						else
							Exception(
								"Cannot autowire object into declaration " +
								"'``prmtrDecl``' of declaration '``decl``'. They both " +
								"produce the same type and no '`` `function qualifier`.name ``' " +
								"has been found, so it cannot be safely autowired.")
					else
						Exception(
							"Cannot autowire object into declaration " +
							"'``prmtrDecl``' of declaration '``decl``' due to the " +
							"following error: ``stap.message``.")
				else
					Exception(
						"No named or autowired annotation found on declaration " +
						"'``prmtrDecl``' of declaration '``decl``'.")
			else
				Exception(
					"Parameter declaration '``prmtrDecl``' of declaration " +
					"'``decl``' must be a value declaration.")))
		
		let (exs = cmpsOrObjsOrExs.narrow<Exception>())
		if (exs.empty) then
			(() {
				value cmpsOrObjs = cmpsOrObjsOrExs
				.collect((Object cmpOrObj) =>
					if (is Component<Object>|
						Container<Object>|
						Collection<Object>|
						Window<Object>|
						Layout<Object>|
						Listener<Object> cmpOrObj) then
						cmpOrObj.val
					else
						cmpOrObj);
				assert (is Type obj = decl.invoke([],*cmpsOrObjs));
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