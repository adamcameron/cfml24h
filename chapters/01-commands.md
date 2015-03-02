# Commands/statements/expressions, variables, operators #

I'll not coddle you too much, and assume you know about variables, expressions and operators, what they're for etc. If for some reason you don't, you're probably not doing yourself any favours by reading this book before doing some basic "Programming 101" sort of study before reading language-specific guidance. But good on you for trying. Maybe you can pick it all up from reading this lot, but it's not the way I'd approach that particular learning exercise.


## Commands / statements / expressions ##

Commands, statements and expressions are the basic units of programming. All are units of work, and the distinction is generally a syntactical one. Wikipedia makes a good distinction bettween statements and expressions (http://en.wikipedia.org/wiki/Statement_%28computer_science%29#Expressions):

* statements are a unit of work - they have side effects (where the main side effect is "your program") - and don't return anything
* an expression returns a value, but otherwise doesn't have side effects.

I've never thought of it that way, but I think it's a reasonable approach to CFML coding. I also add the notion of a command, which is a basic CFML construct like "if" or "return" or "case" etc.

To me, a statement in CFML is an instruction to the program to do something. And an expression is a value used to do something. An expression can - internal to its implementation - contain various statements; a statement is the basic work unit. And commands are the native CFML bits which it intrinsically knows what to do with.

I suppose statements apply an expression to a command? I'll have to think about that. It's tricky because the CFML docs don't actually make these distinctions, so one has to infer the language building blocks from behaviour. This makes documenting it less straight forward.

One important thing to note is that all CFML constructs are case insensitive. This includes statements, function/method names, variable names. Basically everything.


### Commands ###

These are the baseline language constructs like "return", "if", "case" etc. They define program flow, and represent low-level language operations which effect statements, and use expressions.


### Statements ###

A variable assignment is a statement:

```cfc
myVar = someValue;
```

Statements are represented by one of three syntactical constructs:


#### Execution ####

```cfc
return a;
```

This gives a value to a command, and the command does something with it. In this case, the return command takes the value and transfers it back to the calling code.


#### Assignment ####

```cfc
a = b;
```

The left-hand side can be null if one is solely interested in what b does, eg:

```cfc
someObject.aMethod()
```

This acts on the object, but doesn't return a value.


#### Flow control statement ####

```cfc
if (condition) statement(s)
```

When it's a single statement:

```cfc
if (condition) return;
```

Or a block of code:

```cfc
if (condition){
    // multiple statements
}
```

Statements either end with a semicolon:

```cfc
a = b;
return a;
```

Or a block of statements if the command allows it:

```cfc
if (a){
    // multiple statements
}
```

Note that the Lucee CFML implementation make semi-colons optional in almost all situations, but not in some ambiguous situations. My recommendation is to always use them, as the rules as to when they are (/not) needed are poorly defined, so it's a matter of trial and error in one's code.


#### Statement blocks and variable scope ####

In some languages, a variable declared within a statement's block is localised to that block. This is not the case in CFML: CFML has no block-level variable scope.


### Expressions ###

An expression is a construct that returns a value. Ideally (but only ideally) it has no side effects beyond that.

These are expressions:

```cfc
"day after tomorrow: "
1+1
now()
"day after tomorrow: " & dateAdd("d", (1+1), now())
```

A basic string returns a value: the contents of the string. An arithmetic expression returns the answer. A function call returns a value. And any number of expressions can be chained together to form another expression. Each sub-expression's result is used as a step in the main expression.

As a rule of thumb, an expression is a representation of a value. Any time there can be a value, it could be an expression. The only rule is that ultimately, the value of the expression needs to be appropriate to what the next expression is expecting. In my example above, dateAdd() needs a string value as its first argument (and there are rules for the values that string can be), a numeric value for its second argument, and a date/time for its third argument. Then the dateAdd() call itself is an expression too.

Also bear in mind that the key part of control statements (if, for, switch, etc) is also an expression:

```cfc
if (someValue) // do something
```

Here "someValue" is an expression. It simply needs to return a value that is boolean.


### Functions? ###

How do functions - either CFML's own ones, or your own - fit into this? The definition of the functions comprise commands (eg: "`function`") and statements ("```function f(x){/*statements*/}```"). And when you call a function (```f(1)```) it's an expression. You might have a statement that calls a function and assigns the result to a variable(```y = f(1);```).

To muddy the waters, functions can also be declared via function expressions!

```cfc
// declaring function f() via a function statement:
function f(x){
	return x;
}

// defining a function via function expression, and assigning it to a variable f:
f = function (x){
	return x;
};
```

There's reasons to use either of these appraoches, but that's for a later chapter.


### Summary ###

I think all code is pretty much made of statements which apply expressions to commands. With varying degrees of optionality along the way. It might seem like semantics, but being able to identify the individual parts of your code will make it easier to understand the bigger picture of what's going on. To be frank... before writing this stuff down, I didn't have a fully-formed understanding of how it all comes together.


### Warning ###

Both Lucee and ColdFusion's dialects of CFML have constructs that defy reasoning, and might look like expressions but are actually commands, or statements. I'm going to avoid these non-standard constructs if possible, as they are generally avoidable when coding. I might need to add a "caveats" section to this book at some stage (my writing process is very stream of consciousness, and this is only chapter one, so I haven't yet analysed how much discussion this topic needs!)


## Variables ##

OK, so in CFML the basic way variables work is the same as any other language:

```cfc
someVariableName = someValue
```

That said, as with all language-specific implementations, there are some rules and practices. Variable names in CFML can be anything. <code>!&#8364;#&#x2606;</code> is a valid variable name. However you're making your life more difficult than it needs to be by not limiting yourself to a subset of all possible typographical glyphs. There are three (hmmm... two and a half, perhaps) syntax variations. And only one of them will let you call a variable anything.


### Basic ###

The basic syntax is as demonstrated above:

```cfc
someVariable = someValue
```

Using this unqualified syntax, one needs to follow basic variable-naming rules. These are in the docs ([find link]), but currently they are:

> 1. can be any combination of upper and lowercase roman alphabet characters, digits, currency symbols and/or the underscore character.
> 2. that notwithstanding, cannot start with a digit

Bearing that in mind, these are valid:

```cfc
a = 1;
B = 2;
_ = 3;
£ = 4;
```

This is invalid:

```cfc
5c = 5;
```

One other thing to note: CFML is completely case-insensitive. a variable "myVar" is the same as "myvar" or "MYVAR" (except people reading your code will hate you if you use all caps. The CFML runtime won't care. If you want to use all caps, go get a job programming COBOL).

Another thing to note is that in CFML one has to assign a variable a value when declaring it. One cannot simply declare a variable, thus:

```cfc
myVar;
```

One needs to give the variable an initial value, eg:


```cfc
myVar = "";
```


### Dot notation ###

When referencing variables in a specific scope (see relevant chapter), or properties of a specific object, the most syntactically-clear syntax is dot notation:

```cfc
session.isLoggedIn
person.firstname
```

One uses the dot-operator to separate a variable or property (or method) from its scope or object. And if one is using dot notation, the same basic variable rules as stated above apply.


### Associative array notation ###

This is also known as "bracket notation". Its a more "forgiving" notation than dot notation, as the key provided in the brackets can be any string:

```cfc
variables["!€#☆"] = "completely valid variable name";
```

This might seem fairly contrived - my example certainly is - but it opens up two possibilities. Firstly, data doesn't always originate from within the CFML system itself. Database columns can have odd names (with spaces, pound signs, etc), and different languages one might be interconnecting with with CFML will have different naming rules too. This is CFML's way of dealing with that.


#### Dynamic variable names ####

Associative array notation also allows for completely dynamic variable names. The value in the square brackets is just a string, so it can also be a variable containing a string. Or indeed any expression which returns a string. For example:

```cfc
myVarName = "foo";
variables[myVarName]  = "bar";
```

This sets a variable with a name of `foo` to have a value of `"bar"`.

[insert dump here]

Or one could use a function which returns a string as the variable name:

```cfc
variables[createUuid()] = "very unique variable name";
```

[insert dump here]

And given CFML is loosely-typed, any expression which could be interpretted as a string could be used:

```cfc
variables[now()] = "a variable with the current timestamp as its name";
```

[insert dump here]

These examples are all very contrived, but show the general technique. The take-away here is that when using associative array notation, the variable name can be anything.

Another important benefit of associative array notation is that the case of the variable name is preserved. CFML will still treat it case-insensitively, but when data-interchanging between other systems - via say JSON to JavaScript code - it becomes important for variable names to be case-sensitive.


### Coding style ###

In general, use basic notation or dot notation, and - accordingly - simple variable names. In your own CFML code, stick to the rules. Reserve associative array notation for these situation:

* you are interchanging data with other systems with different variable-naming rules,
* or are case-sensitive.
* If you need to reference a variable name dynamically, for whatever reason.

Sticking to these rules make your code more clear. Use the most restrictive syntax where possible (basic notation), only using more complex notation - dot notation or associative array notation - when necessary.


## Operators ##

I discussed above how one expression can be built from other expressions. The missing piece of the puzzle is how expressions are joined together. Operators.

If you stop to think about it: operators exist to apply an operator to one or more expressions. Or when specifically considering operators, they apply an operation to one or more operands (the operands are expressions).


### Unary operators ###

These are applied to a single operand.

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr>
		<td>-</td>
		<td>Switches the sign of a numeric operand</td>
		<td>
<pre><code>x=1;
y = -x; // -1
x = -1;
y = -x; // 1</code></pre>
</td></tr>
	<tr>
		<td>!</td>
		<td>Performs a boolean inverse on the operation</td>
		<td>
<pre><code>!true // false
!false // true</code></pre>

</td></tr>
	<tr>
		<td>++, --</td>
		<td>Short hand increment / decrement</td>
		<td>These either increment (<code>++</code>) or decrement (<code>--</code>) the operand.<br>Unlike other operators, they can be applied either as a suffix (or to linguistically challenged people: "postfix") (<code>i++</code>) or a prefix (<code>++i</code>).<br>The difference is the prefix version applies the operation and then returns the result; whereas the suffix returns the value then applies the operation. See examples for the difference. If one considers the earlier notion that an expression ought not have side effects, then the suffix versions are less than ideal, in a way, as they return one value, but the operand they act on ends up with a different value.<br>Using the suffix version is so ubiquitous that I'd not worry about this too much<br>
<pre><code>x = 1;
y = ++x; // y=2, x=2
z = x++; // z=2, x=3
</pre></code>
		</td>
	</tr>
	</tbody>
</table>


### Binary Operators ###

These take an operand either side of the operator:

```cfc
operand operator operand
```

eg:

```cfc
1 + 2
true || false
```

These are all well-documented, so what I'll advise here is a winnowing of the wheat from the chaff. For example: use the docs to be aware of the ```LESS THAN OR EQUAL TO``` operator (no joke!), but never use it.

Use these ones:


#### Arithmetic ####

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr><td>+, -, /, *</td><td>As you'd expect</td><td>[I won't insult your intelligence]</td></tr>
	<tr>
		<td>%</td>
		<td>Remainder</td>
		<td><code>5 % 2; // 1</code></td>
	</tr>
	<tr>
		<td>+=, -=, *=, /=, %=</td>
		<td>Shorthand operators</td>
		<td>Shorthand equivalents of above operators when acting on the same variable on both sides of the statement, eg: <code>x += 2</code> is equivalent to <code>x = x + 2</code>. This is purely syntactic sugar</td>
	</tr>
	<tr><td>^</td><td>Exponent</td><td><code>2 ^ 3; // 8</code></td></tr>
	</tbody>
</table>


#### String ####

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr><td>&</td><td>Concatenate</td><td>Concatenates two string operands<br><code>greeting = "G'day " & "world"; // "G'day world"</code></td></tr>
	<tr>
		<td>&=</td>
		<td>Shorthand</td>
		<td>
			As per the arithmetic equivalents:<br>
<code>s &= "a"</code><br>
is equivalent to:<br>
<code>s = s & "a"</code>
		</td>
	</tr>
	</tbody>
</table>


#### Boolean ####

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr><td>!</td><td>not</td><td> </td></tr>
	<tr><td>&&</td><td>and</td><td>`and` is short-circuited in that if the first operand is `false` (meaning the entire expression can only be false) it does not evaluate the second operand at all.</td></tr>
	<tr><td>||</td><td>or</td><td>`or` is short-circuited in that if the first operand is `true` (meaning the entire expression can only be true) it does not evaluate the second operand at all.</td></tr>
	<tr>
		<td>XOR</td>
		<td>exclusive or</td>
		<td>
			True if only *one* operand is true:<br>
			<table border="1">
			<thead>
			<tr><th>A XOR B</th><th>B=true</th><th>B=false</th></th>
			</thead>
			<tbody>
			<tr>
			<th>A=true</th>
			<td>false</td>
			<td>true</td>
			</tr>
			<tr>
			<th>A=false</th>
			<td>true</td>
			<td>false</td>
			</tr>
			</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td>EQV</td>
		<td>equivalence</td>
		<td>
			True if both operands are the same:<br>
			<table border="1">
			<thead>
			<tr><th>A EQV B</th><th>B=true</th><th>B=false</th></th>
			</thead>
			<tbody>
			<tr>
			<th>A=true</th>
			<td>true</td>
			<td>false</td>
			</tr>
			<tr>
			<th>A=false</th>
			<td>false</td>
			<td>true</td>
			</tr>
			</tbody>
			</table>
			Basically the inverse of XOR
		</td>
	</tr>
	<tr>
		<td>IMP</td>
		<td>implication</td>
		<td>
			Only if the first operand is true, the second operand must also be true. Otherwise true.<br>
			<table border="1">
			<thead>
			<tr><th>A IMP B</th><th>B=true</th><th>B=false</th></th>
			</thead>
			<tbody>
			<tr>
			<th>A=true</th>
			<td>true</td>
			<td>false</td>
			</tr>
			<tr>
			<th>A=false</th>
			<td>true</td>
			<td>true</td>
			</tr>
			</tbody>
			</table>
			Equivalent to <code>!A || B</code><br>
			<br>
			And example might be in a situation where a function can optionally filter by date, eg:<br>
			<br>
			<code>
			getRecords(boolean filterByDate=false, date date)
			</code>
			<br><br>
			Argument validation could be:<br><br>

<pre><code>argsAreValid = filterByDate IMP structKeyExists(arguments, "date"));<br>
if (!argsAreValid){<br>
    throw(type="InvalidArgumentsException");<br>
}</thead><br>
</code></pre>
			<br><br>
			This operator has a fundamental flaw in that it's not "short-circuited": the second operand is always evaluated even if the first makes the condition true (eg: the first operand is a false condition). This prevents the most useful potential use of this operator which would be:<br><br>

<pre><code>structKeyExists(URL, "someValue") IMP isValidAccordingToSomeRule(URL.someValue) {<br>
   // all good<br>
} else {<br>
    // not so good<br>
}<br>
</code></pre>
			<br><br>
			This fails because the second operand is evaluated even if <code>URL.someValue</code> doesn't exist, which would have caused the first operand to cause a false condition, and the entire expression is therefore false even before considering the second operand.<br>
			<br>
			I also think it's a difficult operator to understand, so simply using <code>!A || B</code> is easier to follow than <code>A IMP B</code>.
		</td>
	</tr>
	</tbody>
</table>


#### Decision ####

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr><td>==</td><td>(These should all be familiar, so I'll not "explain" them)</td><td>Note that this will attempt to cast the operands to numerics, which can result in unexpected results when comparing strings, eg: <code>"007"</code> will be equal to <code>"7"</code>. Use the <code>compare()</code> function for string comparisons in situations where it's important to do a string comparison. Similarly, use <code>dateCompare()</code> to compare dates.</td></tr>
	<tr><td>!=</td><td></td><td></td></tr>
	<tr><td>&gt;</td><td></td><td></td></tr>
	<tr><td>&gt;=</td><td></td><td></td></tr>
	<tr><td>&lt;</td><td></td><td></td></tr>
	<tr><td>&lt;=</td><td></td><td></td></tr>
	<tr>
		<td>CONTAINS</td>
		<td>Checks whether a string contains a substring</td>
		<td>
			<code>a CONTAINS b</code> is true if the string <code>a</code> contains substring <code>b</code>.
			EG: <code>"slaughter" CONTAINS "laughter"</code> is true. Inappropriate, but true.

			I'd use the <code>find()</code> function instead, to be honest.
		</td>
	</tr>
	<tr><td>DOES NOT CONTAIN</td><td></td><td>The opposite of the above</td></tr>
	</tbody>
</table>


#### Conditional assignment ####

<table border="1">
	<thead>
	<tr><th>Operator</th><th>Purpose</th><th>Examples/observations</th></tr>
	</thead>
	<tbody>
	<tr>
		<td>?:</td>
		<td>Assign on null / null-coalescing</td>
		<td>
The result is the first operand if it is defined, otherwise the second operand:<br><br>
<code>
a = 1;<br>
b = a ?: 2; // a is not null, so b=2<br>
c = d ?: 3; // d is null, so c=3<br>
</code>
<br><br>
Sometimes colloquially and unfortunately referred to as the "Elvis operator".
		</td>
	</tr>
	</tbody>
</table>


### Ternary operators ###

There's only one: ```?:```

Yeah, this is not the same as the ```?:``` binary operator. Which is confusing when documenting it. However the usage is different, so there's no ambiguity.

The binary version works like this:

```result = operand ?: operand```

The ternary version like this:

```result = operand ? operand : operand```

Example:

```cfc
coinToss = randRange(0,1) ? "heads" : "tails";
```

```randRange()``` returns a random integer between the two specified boundaries (so in this case the value can be ```0``` or ```1```). In CFML ```0``` is ```false```, and any other numeric value (eg: ```1``` in this case) is ```true```, so this emulates tossing a coin. ```coinToss``` will receive the value either ```heads``` or ```tails```.