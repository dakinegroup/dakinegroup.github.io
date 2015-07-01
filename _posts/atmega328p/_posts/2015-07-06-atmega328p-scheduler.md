---
layout: posts
title: Scheduler for ATMega328p
overview: true
author: Vineet Maheshwari
place: Gurgaon
categories: 
 - atmega328p
tags: 
 - microcontrollers
 - embedded
 - programming
 - scheduler
---
#Dealing with complex situations with timing constraints
Lot of time goes into making things work at hardware level and the enthusiam is also limited to see basic peripherals are working as per expectations. But when it comes to delivering value for end customer, a complex solution would need to be worked out matching to the complex (which may appear simple) requirement of customers.

#When is it required?
In many situations, there would be more than one task which needs to be carried out by mini-controller and most of them are constrained by timing requirements. Peripherals are an interface to external world and by nature they are slower and unpredictable. If processor works in turn with each of them, it may miss out on timing as well as some inputs could be over-written.

It is at this time, interrupts help to capture everything that comes in, a design to breakup huge time-consuming tasks and than scheduler to carry out these pieces in quick succession.

#Understanding the Interrupts
Interrupt by it's definition means, a regular work whatever it may be is interrupted to carry out a higher priority task. At Hardware, this enables to catch events in real-time and store them for later processing. It even can be processed, if it does not take too much time. Program blocks that service these interrupts (ISRs) should take as little clock cycles as possible. Therefore it is always preferred to write them in assembly language.

Interrupt must start by disabling global interrupt flag and end by enabling. Compiler takes care of saving the last instruction address, register values and retrieving them upon return.

All variables that ISR use need to be protected using cli() and sei() commands, to avoid conflicts in reading / writing. These variables are the way of sharing information between ISR and regular program flow.
```
```
#Analysing and Breaking up tasks
#Approach to building final code

#Other useful articles

* Tool Chain for ATmega328p
* Using GIT to manage source
* Tools for PCB Designing

