// Person.cfc
component {

	property firstName;
	property lastName;

	function init(firstName, lastName){
		variables.firstName = arguments.firstName;
		variables.lastName = arguments.lastName;
	}

}