import ceylon.language.meta {
	type,
	annotations
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	FunctionDeclaration,
	InterfaceDeclaration,
	ValueDeclaration
}

import it.feelburst.yayoi {
	ComponentDecl,
	ActionDecl
}
import it.feelburst.yayoi.behaviour.action {
	Action
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegister,
	NameResolver,
	AnnotationChecker
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	OnActionPerformedReaction,
	TitleReaction,
	SizeReaction,
	LocationReaction,
	CenteredReaction,
	ParentReaction,
	ExitOnCloseReaction,
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
	TitleAnnotation,
	LayoutAnnotation,
	OnActionPerformedAnnotation,
	WithLayoutAnnotation,
	WindowEventAnnotation,
	lowestPrecedenceOrder
}
import it.feelburst.yayoi.model {
	modelsComponents,
	frameworkImpls,
	Source,
	frameworkConstrImplConstrs,
	frameworkIntrnlCmpConstrConstrs,
	autowiringFrameworkIntrnlCmpConstrConstrs
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.impl {
	LateSource
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.\iobject.listener {
	DefaultWindowClosedAdapter
}

import java.awt {
	LayoutManager,
	JContainer=Container
}
import java.lang {
	Types {
		classForDeclaration
	}
}
import java.util {
	EventListener
}
import java.util.concurrent {
	ExecutorService
}

import javax.annotation {
	resource
}
import javax.swing {
	JFrame
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.beans.factory.config {
	ConfigurableListableBeanFactory,
	BeanDefinition
}
import org.springframework.context {
	ApplicationContext,
	ApplicationEventPublisher,
	ApplicationEvent
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
import org.springframework.stereotype {
	component
}

component
shared class ComponentRegisterImpl() satisfies ComponentRegister {
	
	autowired
	shared actual late AnnotationChecker annotationChecker;
	
	autowired
	shared actual late NameResolver nameResolver;
	
	resource { name = "frameworkImpl"; }
	late String frameworkImpl;
	
	autowired
	late AnnotationConfigApplicationContext context;
	
	autowired
	late ApplicationEventPublisher eventPublisher;
	
	autowired
	late ConfigurableListableBeanFactory beanFactory;
	
	autowired
	late ExecutorService executorService;
	
	autowired
	late ReactorContext reactorContext;
	
	autowired
	late ActionContext actionContext;
	
	shared actual void register(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) {
		// if component
		if (exists cmpAnn = annotationChecker.component(decl)) {
			log.info("Registering Component '``decl``'...");
			value cmp = registerComponent(decl,cmpAnn);
			// if reactor (e.g. have reactions)
			if (is Component<JContainer>|
				Container<JContainer,LayoutManager>|
				Window<JFrame> cmp) {
				reactorContext.register(cmp.name);
				log.info("Reactor '``cmp``' registered.");
				registerReactions(cmp);
			}
		}
		// else if action
		else if (
			is FunctionDeclaration decl,
			exists actAnn = annotationChecker.action(decl)) {
			log.info("Registering Action '``decl``'...");
			registerAction(decl,actAnn);
		}
		else {
			log.warn("No objects registered for '``decl``'.");
		}
	}
	
	Component<JContainer>|Container<JContainer,LayoutManager>|
	Window<JFrame>|Layout<LayoutManager>|Listener<EventListener> registerComponent(
		ComponentDecl decl,
		ComponentAnnotation|ContainerAnnotation|
		WindowAnnotation|LayoutAnnotation|ListenerAnnotation cmpAnn) {
		// resolve component name
		assert (
			is String cmpName = nameResolver.resolve(decl));
		assert (
			// get component decl
			exists cmpDcl = modelsComponents[type(cmpAnn).declaration],
			exists frmwrkCmpImpls = frameworkImpls[frameworkImpl],
			// get framework component impl decl of component decl
			exists frmwrkCmpImpl = frmwrkCmpImpls[cmpDcl]);
		assert (
			exists frmwrkConstrImplConstrs = frameworkConstrImplConstrs[frameworkImpl],
			// get framework component constructor impl constructor of component decl
			// e.g. given the component decl,
			// get a constructor that, given the framework impl decl, return
			// the implementation of the component constructor
			exists frmwrkCmpConstrImplConstr = frmwrkConstrImplConstrs[cmpDcl]);
		// construct framework constructor impl
		value frmwrkCmpConstrImpl = frmwrkCmpConstrImplConstr(frmwrkCmpImpl);
		// internal component constructor
		value intrnlCmpCnstr = internalComponentConstructor(decl,cmpName,cmpDcl);
		value cmp = instantiateComponent(cmpName,decl,intrnlCmpCnstr,frmwrkCmpConstrImpl);
		log.info("Component '``cmp``' constructed.");
		beanFactory.registerSingleton(cmpName, cmp);
		log.info("Component '``cmp``' registered.");
		return cmp;
	}
	
	JContainer()|LayoutManager()|EventListener() internalComponentConstructor(
		ComponentDecl decl,
		String cmpName,
		InterfaceDeclaration cmpDcl) {
		if (is ClassDeclaration decl) {
			// autowire and register internal component
			assert (
				exists frmwrkIntrnlCmpCnstrCnstrs =
					autowiringFrameworkIntrnlCmpConstrConstrs[frameworkImpl],
				// framework internal component constructor constructor
				exists frmwrkIntrnlCmpCnstrCnstr = frmwrkIntrnlCmpCnstrCnstrs[cmpDcl]);
			function registerBeanDef(String name,Object beanDef) {
				assert (is BeanDefinition beanDef);
				return context.registerBeanDefinition(name,beanDef);
			}
			function getBean(String name,ClassDeclaration decl) {
				return context.getBean(name, classForDeclaration(decl));
			}
			return frmwrkIntrnlCmpCnstrCnstr(decl,cmpName,registerBeanDef,getBean);
		}
		else {
			// only register internal component
			assert (
				exists frmwrkIntrnlCmpCnstrCnstrs = frameworkIntrnlCmpConstrConstrs[frameworkImpl],
				// framework internal component constructor constructor
				exists frmwrkIntrnlCmpCnstrCnstr = frmwrkIntrnlCmpCnstrCnstrs[cmpDcl]);
			return frmwrkIntrnlCmpCnstrCnstr(decl,cmpName,beanFactory.registerSingleton);
		}
	}
	
	Component<JContainer>|
	Container<JContainer,LayoutManager>|
	Window<JFrame>|
	Layout<LayoutManager>|
	Listener<EventListener> instantiateComponent(
		String name,
		ComponentDecl decl,
		JContainer()|JFrame()|LayoutManager()|EventListener()
			intrnlCmpCnstr,
		Component<JContainer>
			(String, Source<JContainer>,Anything(ApplicationEvent))|
		Container<JContainer,LayoutManager>
			(String, Source<JContainer>,Anything(ApplicationEvent))|
		Window<JFrame>
			(String, Source<JFrame>,Anything(ApplicationEvent))|
		Layout<LayoutManager>
			(String,Source<LayoutManager>,Anything(ApplicationEvent))|
		Listener<EventListener>
			(String, Source<EventListener>,Anything(ApplicationEvent))
			frmwrkCmpConstrImpl) {
		void publishEvent(ApplicationEvent event) =>
			executorService.execute(() =>
				eventPublisher.publishEvent(event));
		if (is JFrame() intrnlCmpCnstr,
			is Window<JFrame>(String, Source<JFrame>,Anything(ApplicationEvent))
				frmwrkCmpConstrImpl) {
			return frmwrkCmpConstrImpl(
				name,
				LateSource(decl,intrnlCmpCnstr),
				publishEvent);
		}
		else if (is JContainer() intrnlCmpCnstr,
			is Component<JContainer>(String, Source<JContainer>,Anything(ApplicationEvent))
				frmwrkCmpConstrImpl) {
			return frmwrkCmpConstrImpl(
				name,
				LateSource(decl,intrnlCmpCnstr),
				publishEvent);
		}
		else if (is JContainer() intrnlCmpCnstr,
			is Container<JContainer,LayoutManager>(String, Source<JContainer>,Anything(ApplicationEvent))
				frmwrkCmpConstrImpl) {
			return frmwrkCmpConstrImpl(
				name,
				LateSource(decl,intrnlCmpCnstr),
				publishEvent);
		}
		else if (is LayoutManager() intrnlCmpCnstr,
			is Layout<LayoutManager>(String,Source<LayoutManager>,Anything(ApplicationEvent))
				frmwrkCmpConstrImpl) {
			return frmwrkCmpConstrImpl(
				name,
				LateSource(decl,intrnlCmpCnstr),
				publishEvent);
		}
		else {
			assert (
				is EventListener() intrnlCmpCnstr,
				is Listener<EventListener>(String, Source<EventListener>,Anything(ApplicationEvent))
				frmwrkCmpConstrImpl);
			return frmwrkCmpConstrImpl(
				name,
				LateSource(decl,intrnlCmpCnstr),
				publishEvent);
		}
	}
	
	void registerReactions(
		Component<JContainer>|
		Container<JContainer,LayoutManager>|
		Window<JFrame> cmp) {
		if (exists ann = annotations(`TitleAnnotation`,cmp.decl)) {
			assert (is Window<JFrame> cmp);
			cmp.addReaction(TitleReaction(cmp,ann));
			log.info("Title Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`SizeAnnotation`,cmp.decl)) {
			value sizeReaction = SizeReaction(cmp,ann);
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
		if (exists ann = annotations(`ParentAnnotation`,cmp.decl)) {
			cmp.addReaction(ParentReaction(cmp,ann,context));
			log.info("Parent Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`WithLayoutAnnotation`,cmp.decl)) {
			assert (is Container<JContainer,LayoutManager> cmp);
			cmp.addReaction(WithLayoutReaction(cmp,ann,context));
			log.info("WithLayout Reaction on Component'``cmp``' registered.");
		}
		if (exists ann = annotations(`ExitOnCloseAnnotation`,cmp.decl)) {
			assert (is Window<JFrame> cmp);
			cmp.addReaction(ExitOnCloseReaction(cmp,ann));
			log.info("ExitOnClose Reaction on Component'``cmp``' registered.");
			// if any window has exitOnClose the app cannot terminate properly
			// (e.g. every operation needed for the shutdown)
			// therefore a default window listener is needed
			value dfltWndwClsdCmp = `class DefaultWindowClosedAdapter`;
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
	
	Action registerAction(ActionDecl decl,DoLayoutAnnotation actAnn) {
		assert (
			is String name = nameResolver.resolve(decl));
		assert (
			exists cmpDcl = modelsComponents[type(actAnn).declaration],
			exists frmwrkImpls = frameworkImpls[frameworkImpl],
			exists cmpImplDcl = frmwrkImpls[cmpDcl]);
		assert (
			exists cmpImplDfltCnst = cmpImplDcl.defaultConstructor);
		value cmpMdl = cmpImplDfltCnst
			.apply<Action,[String,ActionDecl,ApplicationContext]>();
		value cmpInst = cmpMdl(name,decl,context);
		beanFactory.registerSingleton(name, cmpInst);
		actionContext.register(name);
		log.info("Action '``name``' registered.");
		return cmpInst;
	}
	
}