# Custom Tags #

NOTES:
Somehow re-invigorate them as a view solution.

On the other hand, maybe show integrating a templating engine for views instead of tags *at all*?



#Creating a custom tags#

Custom tags use a special variable called `thisTag` in order to specify if the tag is in start mode or end mode


```cfm
<cfswitch expression="#thisTag.ExecutionMode#">
<cfcase value="start">
	...
</cfcase>
<cfcase value="end">
	...
</cfcase>
</cfswitch>
```

##About Start##


##About End##


##About Generated Content##



#Importing Libraries#


The `<cfimport>` brings in libraries one whole directory at a time. The import tag has to be near the top of the ColdFusion file. Suppose we had a whole library of tags to make Bootstrap easier to work with. We would import that library with


```cfm
<cfimport prefix="b" taglib="../_bootstrap">
```

We could then use `<b:tag />` anywhere on the page.  Other options include



*	&lt;b3:tag />
*	&lt;bs:tag />
*	&lt;boot:tag />
*	&lt;bootstrap:tag />


#Complete Example#


**_bootstrap/commandButton.cfm**


```cfm
<cfswitch expression="#thisTag.ExecutionMode#">
<cfcase value="start">
	
	<cfscript>
	param attributes.disabled		= false;	if(attributes.disabled == "disabled") attributes.disabled = true;
	param attributes.icon			= "";
	param attributes.iconAlign		= "left";
	param attributes.id				= "";
	param attributes.look			= "default";
	param attributes.name			= "";
	param attributes.processed		= true;
	param attributes.style			= "";
	param attributes.styleClass		= "";
	param attributes.tooltip			= "";
	param attributes.type			= "submit";	// as opposed to reset, use button for buttons
	param attributes.value			= "";		// if this is blank, perhaps an icon should be shown
	
	if (!attributes.processed) exit "exitTag";
	</cfscript>
	
</cfcase>	
<cfcase value="end">

	
	<cfoutput>
	<button 	type	= "#encodeForHTMLAttribute(attributes.type)#" 
			class= "btn btn-#encodeForHTMLAttribute(attributes.look.lcase())# #encodeForHTMLAttribute(attributes.styleClass)#"
	
	<cfif attributes.id		NEQ "">	id		= "#encodeForHTMLAttribute(attributes.id)#"	
	<cfif attributes.name	NEQ "">	name		= "#encodeForHTMLAttribute(attributes.name)#"	
	<cfif attributes.style	NEQ "">	style	= "#encodeForHTMLAttribute(attributes.style)#"
	<cfif attributes.tooltip	NEQ "">	title	= "#encodeForHTMLAttribute(attributes.tooltip)#"
	<cfif attributes.disabled>		disabled	= "disabled"
	><!--- This is the end of the button start tag --->
		
		
	<cfif attributes.icon 		NEQ "" AND attributes.iconAlign EQ "left">
							<i class="glyphicon glyphicon-#attributes.icon#"></i>
	</cfif>
	#attributes.value#										}
	<cfif attributes.icon 		NEQ "" AND attributes.iconAlign EQ "right">
							<i class="glyphicon glyphicon-#attributes.icon#"></i>
	</cfif>
	</button>
	</cfoutput>
	
</cfcase>	
</cfswitch>
```


**MyView.cfm**

```cfm
<cfimport prefix="boot" taglib="../_bootstrap">


...

<boot:commandButton icon="save" value="Save changes" look="danger" processed="#variables.showSaveButtons#" />

```














