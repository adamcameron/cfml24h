<cfscript>
try {
	result = 1 / 0;
} catch (any e){
	writeOutput("type: #e.type#; message: #e.message#");
	throw(type="BadExpressionException", message="The provided expression was invalid", detail="Original exception: #e.type#");
}
</cfscript>