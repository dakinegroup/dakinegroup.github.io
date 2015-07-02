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

```javascript
  <input type="text" name="test1" />
  <script>
     $().ready(function(){
     $("input[name='test1'").val("ipsum");        
     })
  </script>
```

is now replaced with

```javascript
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

#Approach

#Conclusion