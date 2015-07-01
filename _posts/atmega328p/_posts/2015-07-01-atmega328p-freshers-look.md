---
layout: posts
title: ATMega328p - Freshers look
overview: true
author: Vineet Maheshwari
place: Gurgaon
categories: 
 - atmega328p
tags: 
 - microcontrollers
 - embedded
---

#Processor - A Fresher's Look
Today once again interest in 8-bit micro-controllers is rising, primarily because of the urge to inter-connect all devices and they being low-cost option to achieve at large scale. ATMega328p from ATMEL comes as a serious contender, with 32k flash, 8kEEPROM and several peripherals including Analog to Digital Converter - 8 channel multiplexed, 2 8-bit and 1 16-bit timers, PWM generators, separate program and data memory, USART, SPI channels, Pin Change interrupts mapped to 32+ I/O channels.

And all that comes for Rs 120 in India. It's younger sibling, ATMega8 comes for Rs40/- with similar capabilities but little scaled down.

It is up and running with just VCC and Ground, with any other inputs that you would like to be sensed or sending any output over SPI or PWM. It's internal 8MHz clock is sufficient to drive the processor clock. It is rugged, if you accidentally plug it in wrong direction, it won't burn out.

Open source community has several kits and shields are availale at low cost and in plenty to create a prototype solution in no-time and get on with firmware development.

Complexity of configuring various regsiters, calculating accuracy of timing, working out optimal utilization of ports as well as multiplexed functions is there. It is worth the time and is unique in every solution.

It can be learnt easily and used at under-graduate courses to create innovative solutions for home / office / industries / communities. A simple need for any solution requires - measuring, processing and control and again measuring. For example: a student wants to add automation to an electric stove which lacks timer. Solution would require a sensor to measure temperature, a timer to fix how much time one would like to wait and a relay (output) to switch off electric stove. An attachment of WiFi module (costs Rs 320/- in india), will enable remote communications as well, where this mini-controller can take commands remotely to switch on / off.

Few other things that make this process more interesting are:

* Sleep mode and it's ability to work at low power modes
* Self-programming of flash, which enables to add / change functionality on the fly

Other information that can be added:

* when was this process launched
* who are competitors
* who was the original inventor
* what is the exact power consumption
* circuit diagrams of minimalistic 328p
* list other applications
* refer to other blogs on 328p, enabling user to build kits
