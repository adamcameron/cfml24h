<cfscript>
	person = new Person("Abigail", "Bowen");

	writeDump({
		variables = person.getVariables(),
		this = person.getThis()
	});
</cfscript>