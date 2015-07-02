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

An extract from the code for 16-bit timer interrupt:

```C
ISR(TIMER1_OVF_vect)
{
  cli();
  // 4 byte timestamp, that is updated with every expiry of
  //  65535 clock cycles without prescaler
  // at a clock frequency of 12MHz it would be 1/12 usec x 65535 = 4ms
  // change timer control registers to change 4ms to other value
  timestamp[0] ++;
  if(timestamp[0] == 0) {
    timestamp[1] ++;
  }
  // keep this compiler conditional
  #if USE_DEBUG_LED
  if((timestamp[0] & 0x003F) == 0) { 
    // check for lower 6 bits to become zero to
    //  switch on/off debugging LED which gives a time indication
    if(debug_led == 0) {
      debug_led = 0x01;
      PORTB = PORTB | _BV(1);
    } else {
      debug_led = 0;
      PORTB = PORTB & ~(_BV(1));
    }
  }
  #endif
  sei();
}
```

#Analysing and Breaking up tasks
#Approach to building final code

#Other useful articles

* [Tool Chain for ATmega328p]()
* Using GIT to manage source
* Tools for PCB Designing

