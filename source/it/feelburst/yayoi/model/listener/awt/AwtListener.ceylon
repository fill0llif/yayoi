import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.util {
	EventListener
}

import org.springframework.context {
	ApplicationEvent
}
"Awt implementation of a listener"
shared class AwtListener<Lstnr=EventListener>(
	shared actual String name,
	Source<Lstnr> source,
	void publishEvent(ApplicationEvent event))
	satisfies Listener<Lstnr>
	given Lstnr satisfies EventListener {
	
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl =>
		source.decl;
	
	shared actual Lstnr val =>
		source.val;
	
	shared actual String string =>
		name;
	
}