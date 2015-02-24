<cfscript>
try {
	throw(object=createObject("java", "java.lang.Exception").init("This is a Java Exception"));
}catch(any e){
	writeDump(e);
}
</cfscript>