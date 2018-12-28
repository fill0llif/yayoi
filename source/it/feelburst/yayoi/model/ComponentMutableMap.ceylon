import ceylon.collection {
	MutableMap
}

shared interface ComponentMutableMap<Key=String, Item=Anything>
	satisfies MutableMap<Key,Item>
	given Key satisfies String {
	
	shared formal Item? add(
		Item component,
		Boolean internal = true);
	
	shared actual Item? put(Key key, Item item) {
		throw Exception(
			"Component '`` `function put`.name ``' not supported. " +
			"Use '`` `function add`.name ``' instead.");
	}
	
	shared actual void clear() =>
		removeAll(keys);
	
	shared actual MutableMap<Key,Item> clone() {
		throw Exception("Component '`` `function clone`.name ``' not supported.");
	}
}
