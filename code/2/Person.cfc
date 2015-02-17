component accessors=true {
	property firstName;
	property lastName;

	function init(firstName, lastName){
		setFirstName(firstName);
		setLastName(lastName);
	}

	function getFullName(){
		return firstName & " " & lastName;
	}
}