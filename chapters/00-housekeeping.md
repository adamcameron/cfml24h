# Housekeeping #

## 0 ##

First things first: why is this chapter 0? Mostly because the stuff here is nothing to do with learning CFML, it's just the usual wittering on one gets at the beginning of a book. Skip as much of it as you like, but the last section covers getting the development environment I'll be using in the code example sorted out.


## Why? ##

Why am I writing this book? Good question. Basically I think CFML has moved on faster than most of the the learning materials out there have, and those materials are teaching a very old-fashioned way of approaching CFML-written applications. They probably do our community more harm than good by encouraging bad, primitive coding practices. I figure if I take a contemporary approach it will encourage everyone - existing CFML developers and newbies alike - to move on.


## What issues am I addressing? ##

For too long, CFML code was approached from a web-page-centric and tag-based-code-centric perspective. This was fine in 90s and earlier part of this century, but time has moved on, so has CFML, and that approach amounts to "bad practice" these days. You will be learning CFML using almost entirely script syntax, relegating tags to the section on views. In earlier versions of CFML one did still need to fall back to tag-based code for business logic code rather than just view code, but this has not really been the case for a few years now. It's time to accept this.


## CFML? Tags? Script? Huh? ##

The previous paras perhaps won't mean much to someone who is completely ignorant of CFML. But then again I doubt anyone who is completely ignorant of CFML will be reading it. If you are... at least go read the Wikipedia page on CFML (http://en.wikipedia.org/wiki/ColdFusion_Markup_Language) to get a handle on its history and general information about it.  This is not a history book, so I'm not covering that stuff. Except for a bit of context, a few paras below.

As it currently stands, CFML is a web-centric, loosely and dynamically typed language aimed at developing web-based applications and web sites. It arrived on the scene around about the same time as PHP, so it's one of the founding members in that space.

Typical CFML code looks similar to most "curly-brace" languages:

```
name = "Zachary";
writeOutput("G'day #name#"); // G'day Zachary
```

In this example I demonstrate setting a variable `name`, and outputting as part of an interpolated string, resulting in *G'day&nbsp;Zachary*

Most CFML code should be written using this "script" syntax, however CFML also has a tag-based syntax used in view files. The equivalent tag-based code for the above example would be:

```
<cfset name = "Zachary">
<cfoutput>G'day #name#</cfoutput> <!--- G'day Zachary --->
```

It has a resemblance to HTML, and is designed to integrate and intermingle with inline text such as HTML within a view file.

The language is processed by a Java servlet running on Tomcat or JBoss or some other servlet container, which compiles CFML source code to Java byte code, and executes it. This all happens when a request is received by a web server, and the web server has been configured to pass requests to the servlet container and onto the CFML servlet. The CFML servlet works out what code it needs to fulfil the request, compiles it, runs it, and returns any generated data (say: HTML or JSON) to the web server. The web server then sends that back to the client browser to do with it what it will.

It's important to note that CFML is a language, it is not a servlet in itself. At present, there are two main vendors who provide a CFML-processing servlet: Adobe and Lucee.

Adobe has a closed-source, paid for product - ColdFusion -  which is aimed at the enterprise market. Adobe inherited the ColdFusion product from their purchase and subsumption of Macromedia; Macromedia had previously done the same thing to Allaire, the original creators of "Cold Fusion". ColdFusion is not a flagship product of Adobe, and it has mostly been languishing in one of their backwater development departments since it became an Adobe product. It does seem occasional development, but the impression I get is that Adobe only persist with ColdFusion whilst the client-base they purchased as part of Macromedia continue to pay their licence renewals. ColdFusion is currently at version 11. Adobe release a new version of ColdFusion every couple of years. In the interim they will release one or two service packs for the currently-supported ColdFusion releases (only versions 10 and 11 are currently supported; support for version 9 ended at the end of 2014).

Railo was a company who lead the Railo open source project. The Railo solution was free and open source, and was more actively developed than ColdFusion. In its early days Railo was positioned as a free alternative to ColdFusion, and definitely positioned itself in ColdFusion's larger shadow.  Because it was an open source project, Railo is continuously releasing new version of the language, both adding new features and fixing bugs.

Whilst I was writing this the Railo project basically ended, and was replaced by Lucee. The reasons for this are outwith the remit of this book.

Lucee is currently on version 4.5. Note that the ColdFusion version number and the Lucee version number bear no relation to each other (this is sometimes confusing).

There is another CFML-esque implementation: Open BlueDragon. I mention that only for completeness: it is mostly irrelevant these days, and this will be the only mention of it in this book.

For many years the ColdFusion product was the only CFML servlet available, hence sometimes "ColdFusion" is used to mean "CFML". However ColdFusion is a servlet (well: a bunch of servlets, re-licensed third party Java libraries and an administration UI), and CFML is the language. This book is about the language CFML, not about ColdFusion. However in this book I will be using ColdFusion 11's implementation of CFML for my code examples. Where possible I will use code that will run on both ColdFusion 11 and Lucee 4.5. I will mention vendor differences only when it's necessary for the example. I hope that one will be able to focus on the code and not worry about the vendor as much as possible throughout this book.


## Cameron ##

Who am I? I'm Adam Cameron and I've been a CFML developer since early 2000. Throughout most of that time, I have been solely a CFML developer, with just a smattering of JavaScript on the site. I have been an active participant in the CFML community for that long too: helping people with problems via various Q&A forums, helping Adobe on the ColdFusion Pre-Release Program, and also putting my oar in in the Lucee community too. I know CFML pretty well, and figure my take on it is possibly worth writing down. I primarily used ColdFusion (version 9) for my day job. I say "used" in the past tense as I now mostly work with PHP, but I remain part of the CFML community.


## You ##

I'm writing this from the ground up, so should be suitable for a newbie to CFML. I will kind of assume a certain pre-knowledge of programming terminology in places though. I also hope it'll be beneficial for existing CFML devs to read as well. Hopefully I can teach old dogs new tricks too. Or at least get them snarling in disagreement with me.


## 24 hours ##

Well... take that with a grain of salt. It's a cliched title, but it sets the scene as to the general approach I shall take. I am not going to time how long it takes to read and absorb each chapter, but I will be breaking sections down into bite-sized chunks. That said, you should probably assume the book-based part of the learning process might take an hour per section, but it's then over to you to actually learn it. One cannot learn anything from just reading a book, these pages are just information dissemination. It's up to you to then take that information and learn from it. The code examples will be minimal: you're expected to then write your own code and experiment sufficiently to become comfortably with it. As one of my tutors at polytech (back in the early 1990s this was) was wont to say "I'm not here to teach, you're here to learn".

Also I shall not be covering everything in CFML in this book. I will be teaching the syntax, data types, constructs, and elements of functionality sufficient to get you productive. This is not a reference (as some tomes tend to be), there is online documentation for that. There's also an awful lot of CFML that one simply doesn't need to know. There's perhaps 500 top-level functions in the CFML language, and I've probably not used half of them. And there's possibly 100 tags and you should only ever used about a dozen of them. There is no value in knowing a lot of this stuff. There is also no value in teaching about them all, because a function is a function... once one knows how to use functions, one can then use the online docs to reference the rest of them.

Similarly stuff like generating images, PDF files, charts, what-have-you - all of which CFML has support for - is tangential to the core language, and I don't think there's any need to discuss that sort of thing here. I'm going to get you a good handle on the core of CFML, and that'll enable you to work the rest out for yourself.

I'm also not going to waste time discussing how to install either ColdFusion or Lucee: this is already well documented by the vendors themselves. Obviously at some point you are going to have to install ColdFusion so as to run some code, but not straight away. I'm not going to discuss how to install a  database server: again, the vendors have done this. You're not going to need a DB for anything in this book anyhow. I'm not going to discuss HTML, HTTP, server administration, maintenance or security. None of that stuff has anything to do with the CFML language, and there are better resources around for all that stuff. I hasten to add this is all vital information for you to know, but it's not my job here to teach you it. This is about CFML.


## Running the code ##

You've got a few choices. The is an online service [trycf.com](http://trycf.com) which allows one to type & run CFML code entirely online. So there's no installation necessary to use that, but it's fairly limited in what it can do: you're limited to a single file, for one thing.

There is also [CommandBox from Ortus Solutions](http://www.ortussolutions.com/products/commandbox). This is easy to install (download, unzip, run), and I shall be using this for my code examples in the book. This has both a REPL for running small amounts of code interactively, but also includes the ability to run file-based code as well.

If you want a local install, you could download and install [ColdFusion Express](https://www.adobe.com/products/coldfusion-family.html#content-dotcom-en-products-coldfusion-family-bodycontent1-ttt-1), which - again - is download, unzip, run. The benefit of installing ColdFusion is that one can run entire applications with it, so is perhaps easiest in the long run.


## IDE? ##

You don't need one. I don't use one. All you need is a text editor, although one with CFML support might be helpful once you move on from just a few lines of code. For my coding at work I use [SublimeText](http://www.sublimetext.com/), with the [CFML plug-in](https://packagecontrol.io/packages/CFML). For most of the code in this book using CommandBox's REPL will probably actually be fine. Whilst CFML needs to be compiled to run, this is all handled via the servlet, when the code is requested. It's transparent from your perspective: there is no build process or anything like that, and you never even see the compiled files. The servlet takes care of all that for you.


## CommandBox ##

Go and download it and unzip it into a directory, eg C:\apps\commandbox. Stick that directory in your path (just to save time having to type it in the whole time). Drop down to a command prompt and type:


    > box repl


All things going well, you should be greeted with something like this:



    C:\temp>box repl
    Enter any valid CFML code in the following prompt in order to evaluate it and print out any results (if any)
    Type 'quit' or 'q' to exit!
    CFSCRIPT-REPL:

From there type in:

    writeOutput("G'day World");


and press enter (I'm going to assume you know how to type stuff from now on, OK?)

You will get something like this:


    Type 'quit' or 'q' to exit!
    CFSCRIPT-REPL: writeOutput("G'day World");
    => G'day World
    CFSCRIPT-REPL:


Cool. We're off...

(NB: yeah, I know that wasn't a whole hour. There's no point in being too slavish about these things).
