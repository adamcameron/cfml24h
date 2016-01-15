# MVC basics #

NOTES:
Start with something like Nolan's presentation at CFSummit 2015 re MVC without a framework, as I think that describes MVC really well.

Show how an established framework like FW/1 can remove a lot of hand coding if a dev is tempted to DIY.


For pull requests, initially let's just do section subheadings to first arrive at a structural consensus.

Don't submit pull requests for content yet.


### FW/1 ###


Usage FW/1 uses Application.cfc and simple conventions to provide an MVC framework in a single file.




**/Application.cfc**

```cfc
component  extends="framework.one"   {

  this.name= "Sample";
  this.sessionManagement = "yes";
  this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0); 

  variables.framework = {
    home    = 'main.home',
    baseURL = 'useCgiScriptName',
    trace   = isDebugMode()
    };

variables.framework.routes = [
  { "main/{id:[0-9]+}"  = "main/home/id/:id"},
  { "main/home"         = "main/home"}
  ];

}
```

**/framework**

FW/1 files go here


**/views/main/home.cfm**

```cfc
<cfparam name="rc.id" default="Guest">

<p>Welcome to FW/1, <cfoutput>#getSafeHTML(rc.id)#</cfoutput><p>
```


Documentation and Blog:
http://framework-one.github.io/


Source Code and Examples for FW/1:
https://github.com/framework-one/fw1


