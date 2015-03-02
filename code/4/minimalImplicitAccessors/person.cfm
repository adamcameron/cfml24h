<cfscript>
	person = new Person("Abigail", "Bowen");

	writeDump({
		firstName = person.firstName,
		lastName = person.lastName
	});

</cfscript>