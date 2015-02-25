component accessors=true {

	property firstName;
	property lastName;

	function init(firstName, lastName){
		variables.firstName = arguments.firstName;
		variables.lastName = arguments.lastName;
	}

	function getVariables(){
		return variables;
	}

	function getThis(){
		return this;
	}

}