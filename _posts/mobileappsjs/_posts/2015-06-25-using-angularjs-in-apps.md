---
layout: posts
title: Using Angular JS in apps
overview: true
author: Vineet Maheshwari
place: Gurgaon
categories: 
 - mobileappsjs
tags: 
 - Apps
 - Mobile
 - Javascript
 - AngularJs
---

#Introduction 
JQuery continues to hold it's dominance when it comes to user interface WoW effect and has become a fundamental to any other framework. AngularJs has change the track from regular method based UI functionality. It has divided user interface into layers and worked to improve the readability, maintenance of UI code. It is not a replacement of JQuery. AngularJs divides UI into three layers essentially, 


* front end with special directives
* model structure in the backend
* controller where the first control lands as page gets loaded
* communication model (REST / JSON) to talk to the server for information submission / retrieval

AngularJs, this way has enabled to breakup the work of complex UI and expedite development. Also, it has become easier to maintain.

A code that used to be written as following:

```
  <input type="text" name="test1" />
  <script>
     $().ready(function(){
     $("input[name='test1'").val("ipsum");        
     })
  </script>
```

is now replaced with

```
  <!-- referred as view component of front end -->
  <input ng-model="test1" />
  <script>
    //inside a controller
    // referred as backend for the view
    $scope.test1 = "ipsum"; // test1 is the model being referred by
  </script>
```

#Javascript - Omniscient behaviour
Capability of Javascript to perform event based processing has attracted developers to take it to server, embedded and database platforms. This has enabled several new technologies to come up and made it a language of the modern times. Gone are the days, where one was able to say "Good at javascript" by just reuse of available scripts on their web page. Now, there are whole set of design paradigms, performance considerations, knowing details of JS execution has become important.

It is significant change from traditional programming paradigm. It is single threaded behaviour, giving control in the hands of designer to schedule tasks and keep them engaged as is necessary. Object and no class concept, is another significant difference from traditional object oriented understanding. By default, Javascript works on structure, which are labelled as objects and their meta structure called as prototype. Inheritance, polymorphism, public/private data are all design patterns of OOPS.

OOAD and Event driven programs make it excellent alterantive to traditional languages for creating end to end solution.

#Easier Testing alternatives
It provides easier testing alternatives to native platforms, where it requires to learn Java, it's eco system and nuances of mobile app deployment. One has to use emulator in case of native environment. In case one is using AngularJS and javascript driven app environment, it can be tested for most of the logic building inside browser. For functionality accessing native mobile functionality like address book, one can write stubs and reuse them over projects. Once we are on browser platform, rest of it debugging, inspecting elements, working user interface events are all easy to work with and troubleshoot.

From android / iPhone perspective such applications are making use of WebViews heavily, which basically uses HTTP transport to retrieve/send information from servers and also parses HTML content to create user interface.

Testing tools like "karma" - test runner, "jasmine" - test suite meta language helps user to do unit testing, where it constantly monitors changes in javascripts, deploys them and run the test cases in a ziffy, thereby raising any errors as we write the code. It also helps to do integration / system tests where components are tested when put together, there are stubs at function level, but exist at the level of network interface. It uses "selenium" framework at the backend, emulates user action and captures the UI output for verification. It is pretty slow and can be left for overnight run to find all faults left in integration cases.

Major advantage that one gets through use of javascript based approach is that it is done once and through use of plugins (ported across different mobile platforms), it is able to launch applications at several platforms.

#Plugins
Plugins - many are available standard out of the box with support of various hardware and operating systems. Where there is a specific need, one has to create plugin. Also, plugin may be needed to put critical business logic code into java / objective-c to prevent copying of source by competitors.

#Approach

Using angularjs for mobile app development, following can be done:

* use requirejs alongwith angularjs, to dynamically load js as and when required. this optimizes the startup time
* also use ui-router to manage user interface states, which other wise has got limited implementation in angular-router.js
* all code should be put into various modules, aligned with real life scenarios. This includes one module for utility and communication each
* as app is bootloaded with requirejs, main app is created with corresponding view loaded
* it actually becomes single context, single page application, where variables declared in global context stays for as long, as page is never getting reloaded
* create hierarchy structure of objects, well supported through ui-router as well, to reuse UI components
* stub interfaces which require native services of a mobile or reuqire communication over internet
* make everything automated using grunt
* generate html using JADE
* generate css using compass
* lint i.e. check for errors in javascript before deployment using jshint
* use sub-modules for repositories as such using package.json or .bowerrc files
* deploy means copy all relevant files, whenever they change, to directory from where apache can serve static files / javascript for testing
* deploy may also mean putting things together for cordova or ionic to create mobile deployable package and launch it to emulator or actual target platform

#Flip-side
A developer can easily, in case of android, hack into the operating system and download all the files (readable) for modification / reuse.

#Conclusion
Lot of effort might be saved in development in initial stages, if one uses hybrid platform (Javascript based frameworks for mobile apps). In long run, for sustainable competitive advantage, one has to work on fine balance between what remains as part of JS and what goes in Java. Too much on either side will cost on performance or security or time to market.