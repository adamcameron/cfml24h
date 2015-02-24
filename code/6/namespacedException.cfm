<cfscript>
try {
	switch (randRange(1,3)){
		case 1:
			throw(type="com.mydomain.myapp.SomeException");
		break;
		case 2:
			throw(type="com.mydomain.myapp.SomeOtherException");
		break;
		default:
			throw(type="DifferentException");
		break;

	}
} catch(com.mydomain e){
	writeOutput("com.mydomain exception caught: #e.type#");
} catch(any e){
	writeOutput("Any other sort of exception caught: #e.type#");
}
</cfscript>