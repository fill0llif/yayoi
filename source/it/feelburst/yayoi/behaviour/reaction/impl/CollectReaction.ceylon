import ceylon.interop.java {
	CeylonMap
}
import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	NameResolver
}
import it.feelburst.yayoi.behaviour.listener.model {
	WindowSetup
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	OrderingAnnotation,
	NamedAnnotation,
	CollectAnnotation
}
import it.feelburst.yayoi.model {
	Declaration,
	Reactor
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection,
	Collection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent,
	Component
}
import it.feelburst.yayoi.model.container {
	Container
}
import it.feelburst.yayoi.model.visitor {
	Visitor,
	DepthFirstTraversalByParentVisitor
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext,
	ApplicationEventPublisher
}
shared class CollectReaction(
	shared actual Window<Object> cmp,
	shared actual CollectAnnotation ann,
	ApplicationContext context)
	satisfies Reaction<Window<Object>> {
	shared actual void execute() {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value evntPblshr = context.getBean(classForType<ApplicationEventPublisher>());
		//add components
		value prtTrvCltrVstr = DepthFirstTraversalByParentVisitor(context);
		prtTrvCltrVstr.visitor = object satisfies Visitor {
			Boolean|Exception internal(AbstractComponent component) =>
				//if there are no layout actions, container's layout has not been addressed,
				//therefore components must be added to the container at framework impl level
				//if component has a parent
				if (is Reactor&Declaration cmp = component,
					exists prntRctn = cmp.reactions<>()
					.narrow<ParentReaction>()
					.first) then
					//get component parent container
					let (cntrName = nmRslvr.resolveNamed(cmp.decl,prntRctn.ann))
					//if does not exist a layout action for the container then add internal
					!CeylonMap(context.getBeansOfType(classForType<LayoutAction>()))
					.items
					.find((LayoutAction lytAct) =>
						let (lytName = nmRslvr.resolveNamed(cmp.decl,lytAct.ann))
						lytName == cntrName) exists
				else
					Exception(
						"Cannot determine if internal add should be called. Component " +
						"'``component``' has no parent.");
			
			shared actual void visitComponent<Type>(Component<Type> visited) {}
			shared actual void visitCollection<Type>(Collection<Type> visited) =>
				visitAbstractCollection(visited);
			
			shared actual void visitContainer<Type, LayoutType>(
				Container<Type,LayoutType> visited) =>
				visitAbstractCollection(visited);
			
			shared actual void visitWindow<Type>(Window<Type> visited) =>
				visitAbstractCollection(visited);
			
			void visitAbstractCollection(AbstractCollection&Declaration visited) {
				value addComponent = ann.agent(visited).apply;
				(if (exists ordAnn = annotations(`OrderingAnnotation`,visited.decl)) then
					ordAnn.named.collect((NamedAnnotation named) =>
						context.getBean(
							nmRslvr.resolveNamed(visited.decl, named),
							classForType<AbstractComponent>()))
				else
					prtTrvCltrVstr.children(visited))
				.each((AbstractComponent cmp) {
					value addInt = internal(cmp);
					if (is Boolean addInt) {
						addComponent(cmp, addInt);
						log.debug(
							"Reaction: Component '``cmp``' has been added to Collection '``visited``'. " +
							"Framework impl. add method has ``if (addInt) then
							"" else "not "``been called.");
					}
					else {
						throw addInt;
					}
				});
			}
		};
		
		prtTrvCltrVstr.visitWindow(cmp);
		log.debug("Reaction: Collect operation requested for Window '``cmp``'.");
		evntPblshr.publishEvent(WindowSetup(cmp));
	}
}