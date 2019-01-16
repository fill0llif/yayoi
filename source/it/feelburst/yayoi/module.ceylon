native("jvm")
module it.feelburst.yayoi "4.1.1" {
	shared import java.base "8";
	shared import javax.javaeeapi "7.0";
	shared import java.desktop "8";
	shared import ceylon.logging "1.3.3";
	shared import ceylon.collection "1.3.3";
	shared import maven:org.springframework:"spring-context-support" "4.3.2.RELEASE";
	import ceylon.interop.java "1.3.3";
	import ceylon.time "1.3.3";
}
