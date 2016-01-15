# File system / HTTP / FTP #

NOTES:
General file ops.




#Interacting with Directories#




#Interacting with Files#

In todays sophisticated web applications, it is common to use 3rd party Cascading Style Sheet (CSS) and Javascript (JS) libraries. It is not unusual to see a half a dozen to a dozen being used. Using a single library is straight foreward. Just use the HTML `<link>` tag 


```html
<link rel="stylesheet" href="vendor/css/bootstrap.min.css">
```

But what happens when more and libraries are need? Does one just keep adding `<link>`s ?


```html
<link rel="stylesheet" type="text/css" href="vendor/css/bootstrap-theme.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/datepicker.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/daterangepicker-bs3.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/datatables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/select2.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/select2-bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/material.min.css">
<link rel="stylesheet" type="text/css" href="vendor/css/blog.min.css">
```

This has a new set of issues. Every time a new CSS file is `<link>` ed, the browser has to initiate a new network reques, download the file, parse the file, and apply it to the site. This slows down the overall load process of the web application. A better way would be to have a single request that includes all of the CSS. We are going to create a file that we can reference with

<link rel="stylesheet" href="vendor/cache/concat.css">

We are goint to create this as a function. This function will be able to cover CSS, JS, and any other kind of file we need to concatinate. Overall the process

* Delete old file
* Read new files into a variable
* Write new file


##Safely deleting the old file##

It is tempting to use the `FileDelete()` function directly.

```cfc
boolean function processVendor(required string renderFile, required string baseDir, required string lstSource) output="false"	{

	FileDelete(arguments.renderFile);

	...

	return true;
	}
```

The problem with this approach is that the file may not even exist or worse yet, ColdFusion may not have enough permission to do the delete.

```cfc
boolean function processVendor(required string renderFile, required string baseDir, required string lstSource) output="false"	{	
	try	{
		if (FileExists(arguments.renderFile)) FileDelete(arguments.renderFile);
		}
	catch (any e)	{ return false; }
	...

	return true;
	}
```

We use `FileExists()` to make sure the file is there. We wrap the whole thing in a try/catch block. The alternative would to attempt to account for every reason that a file that exists is un-deleteable. It is simplier to just have the function politely give up. If it turns out that files are often un-deleteable, it may be useful to return back `e.message` instead.

Also see: try/catch



##Reading files##

We are going to assume that the files that we are reading has the same extension as the file we are writting 

```cfc
local.renderExt = "." & listLast(renderFile, ".");
```

Now we are going to setup a string that will will be concatinating too

```cfc
local.renderString = "";
```

ColdFusion's `for` loop cannot look through a list directly, but it can loop through an array

```cfc
for (local.myFile in ListToArray(arguments.lstSource))	{
	...
	} // end for
```

Now we read the files. We want to make sure that we don't crash if the file is missing. All of our files are expected to be pre minified.

```cfc
for (local.myFile in ListToArray(arguments.lstSource))	{
	// even if file does not exist, process should continue
	if(FileExists(arguments.baseDir & trim(local.myFile) & local.renderExt))	{
		local.renderString &= FileRead(arguments.baseDir & trim(local.myFile) & ".min" & local.renderExt);
		}
	}	// end for
```


Also see: Resources on Minification


##Writing the file##


```cfc
FileWrite(arguments.renderFile, local.renderString);
return true;	
```

##The whole function##

```cfc
boolean function processVendor(required string renderFile, required string baseDir, required string lstSource) output="false"	{
	
	try	{
		if (FileExists(arguments.renderFile)) FileDelete(arguments.renderFile);
		}
	catch (any e)	{ return false; }


	local.renderExt = "." & listLast(renderFile, ".");
	local.renderString = "";

	for (local.myFile in ListToArray(arguments.lstSource))	{
		// even if file does not exist, process should continue
		if(FileExists(arguments.baseDir & trim(local.myFile) & local.renderExt))	{
			local.renderString &= FileRead(arguments.baseDir & trim(local.myFile) & local.renderExt);
			}
			
		if(FileExists(arguments.baseDir & trim(local.myFile) & ".min" & local.renderExt))	{
			local.renderString &= FileRead(arguments.baseDir & trim(local.myFile) & ".min" & local.renderExt);
			}
		}	// end for
			
	FileWrite(arguments.renderFile, local.renderString);
	return true;	
	}
```


##Putting it all together##
So how do we run this?

**Application.cfc**

All these examples have been showing this for CSS. This approach works for JS too. For simplicity, the code assumes that processVendor is in the `application.cfc` file. The function can be placed anywhere

```cfc
void function onApplicationStart()	{
	...
	application.GSBASE		= replace(cgi.script_name, "/index.cfm", "") & "/";
	application.GSVENDOR		= application.GSBASE & "vendor/";
	...
	
	this.processVendor(application.GWVENDOR & "cache\concat.css", application.GWVENDOR & 'css\',
		"bootstrap, bootstrap-theme, daterangepicker-bs3,
		dataTables.bootstrap, select2, select2-bootstrap,
		blog, material");
		
	this.processVendor(application.GWVENDOR & "cache\concat.js", application.GWVENDOR & 'js\',
		"jquery, bootstrap, bootstrap-maxlength,
		eldarion-ajax, moment, daterangepicker,
		jquery.dataTables, dataTables.bootstrap, dataTables.fixedcolumns, datatables.colvis,
		select2");	
	...
	}
```

**On Layout**

```html
<link rel="stylesheet" href="vendor/cache/concat.css">
<script src="vendor/cache/concat.js"></script>
```

> **Caution**
> CSS files often have references to font files. In the orginal example, the path the the css was `vendor/css`. In the new one it is `vendor/cache`. If the CSS file expects that the font file is in the same directory, it will fail. It is recommended that all fonts be in `vendor/fonts`.  That way the css to font path is always up one directory and down into fonts. 







