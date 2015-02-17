<cfscript>
letters = ["a", "b", "c", "d", "e", "f"];

oddLetters = letters.filter(function(letter, index){
    return index MOD 2;
});	
</cfscript>