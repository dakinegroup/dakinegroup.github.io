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

<pre>
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
  if((timestamp[0] &amp; 0x003F) == 0) { 
    // check for lower 6 bits to become zero to
    //  switch on/off debugging LED which gives a time indication
    if(debug_led == 0) {
      debug_led = 0x01;
      PORTB = PORTB | _BV(1);
    } else {
      debug_led = 0;
      PORTB = PORTB &amp; ~(_BV(1));
    }
  }
  #endif
  sei();
}
</pre>

#Analysing and Breaking up tasks
Now using interrupts, it is possible to manage external world without wasting time in waiting for them to get ready. This is primarily needed for inputs Or to trigger events, where controller can be commanded to send an output. Our main loop should be such that it goes around different functions or we may call it as state machines. In these state machines, saved input data (coming from interrupts) is looked at and next action is either taken or scheduled. Actions may involve moving to next state, trigger some output or just ignore.

A framework can be designed with following components:

* Regisration: An object that maintains functions list alongwith the timestamp, when they would be taken up next. These functions are the entry to state machine
* Invocation: In loop it goes through this object to find and execute if any of the statemachines is due for execution

Programmer need to take care of not allowing time consuming actions to hold the controller, thereby causing others to fail to respond.

Registration code for example:

<pre>
void repeat(int ms, tTimedCallBack cb) {
int i = 0;

    //add scheduled item to the queue
    for (i = 0; i < MAX_TASKS; i++) {
        if(scheduledItems[i].empty) {
            cli(); //protected block
            scheduledItems[i].timestamp[0] = timestamp[0];
            scheduledItems[i].timestamp[1] = timestamp[1];
            sei();
            scheduledItems[i].timestamp[0] += ms;
            scheduledItems[i].recurrence = ms;
            scheduledItems[i].cb = cb;
            
            scheduledItems[i].empty = 0;
            break;
        }
    }
}

</pre>

Lets say one has to write to a LCD display. Steps to write a string here would be

* goto the location
* read next character
* write a character first nibble
* write a character second nibble
* read again

one can schedule writing 4 characters at a time, with an interval of 100ms inside state machine, a cycle does not complete till all are written out, therefore as soon as it starts, it saves all the global/interrupt owned registers/values for use across state machine cycle. This is the simplest break up. It needs to be abstrated with a function that further drives a state machine. This state machine is repeated invoked in loop, for finishing of scheduled tasks. These state machines are like server performing tasks in background.

Maintain functions as function pointers in an array with mapping to events. This can be further extended to capture variables values and associated next state. A typical function pointer which takes integer as an argument and returns integer would be:

<pre>
typedef int (* tTimedCallBack)(int);
</pre>

#Approach to building final code

Breaking up things into smaller modules and components is the way to go. A big code being dealt at a time is a time waster and frustrating. So, one should breakup the embedded project into smaller peripheral driven projects / tasks. One should evolve their source / library around that peripheral with following two objectives in mind:

* Develop ISR in C or assembly language, write initialization routine to drive this ISR
* Develop driver that acts as interface to user program logic for reading / writing to peripherals.
* Developer test user program to test above two things.

Such code shall be easy to debug, take lesser time to be flashed on controller.

This phase of development may be called - peripheral component development.

Next comes evolve frameworks like scheduler, state machine, memory allocation, log handling - which basically form the fabric of application software. This may be done on machine to test the flow, logic and later ported to target platform. In this case, one need to protect code that is incompatible using #ifdef

Last in the process is integration of required components and fixing integration issues. This will be toughest of all and is highly inefficient because of getting involved with slower target platform and difficult to debug faults. Here the best way to troubleshoot is to do code-reviews.

#Other useful articles

* [Tool Chain for ATmega328p](/atmega328p/2015/07/08/atmega328p-tool-chain.html)
* Using GIT to manage source
* Tools for PCB Designing

