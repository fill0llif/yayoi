shared interface Collector<Collector,Collectable>
	given Collector satisfies Object
	given Collectable satisfies Object {
	shared formal Anything collect(Collector cltr,Collectable cltbl);
	shared formal Anything remove(Collector cltr,Collectable cltbl);
}
