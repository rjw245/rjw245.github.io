---
layout:     post
title:      Basic Preemptive Scheduler on an MSP430
date:       2017-04-10
summary:    Overview of schedulers & a basic implementation.
thumbnail:  clock-o
tags:
- operating systems
- msp430
- preemptive scheduler
---

# Table of Contents
{:.no_toc}

* TOC
{:toc}

# Introduction

## The scheduler

The scheduler is one of the core components of an operating system. It's what allows multiple programs to all run at once on the same CPU and not have to know anything about one another. This is one of the most important knowledge barriers an operating system provides since it means separate programs can live separate lives and be developed in a vacuum. Imagine if every program on your computer had to share the same main loop! Suffice it to say software development would be much more difficult.

In this post I'll talk about how I designed and implemented a simple preemptive scheduler for the [MSP430 Launchpad board from TI](https://www.ti.com/tool/msp-exp430fr4133){:target="_blank"}. I have always been a fan of learning by doing, and this was a certainly an excellent bit of learning for me. But first, some more background info is necessary.

Ok: so what is a *preemptive* scheduler? Well, there are basically two kinds of schedulers: preemptive and cooperative. These describe the knowledge barrier that exists between the program and the underlying OS. In any scheduler, you'll write separate tasks aka programs aka processes. The difference is that in a cooperative scheduler, tasks actively give up control to the operating system by calling a function, which lets the OS switch to a different task. It's called "cooperative" because tasks have to voluntarily "cooperate" with one another. In a preemptive scheduler, though, things are different. The task has no say in when it gets to run versus another task. The operating system gets to interrupt tasks whenever it wants and switch to a different one. These are most common in today's general purpose operating systems. The value of a preemptive scheduler lies in its stronger knowledge barrier and resistance toward greedy processes. There doesn't need to be any interface between the task and the scheduler for a context switch to happen, and the task can't easily hog the CPU by refusing to yield control.

There is an entire field of research focused on how the scheduler picks the next task which it should run -- this is known as the scheduling algorithm. Usually there is some notion of task priority which makes some tasks more likely to run than others. When choosing a scheduling algorithm, operating systems designers have several goals, namely avoiding resource starvation (when a task is repeatedly denied access to some hardware/software resource), and allocating CPU time fairly. [Read more on Wikipedia.](https://en.wikipedia.org/wiki/Scheduling_(computing)#Scheduling_disciplines){:target="_blank"}

For this project, my main focus was on implementing a context switch successfully, so my scheduling algorithm is extremely simple. It's a round robin scheduler with no notion of task state meaning each task will be run for an equal amount of time in the order they were started (even the idle task). A bit silly, I know, but improvements to the scheduling algorithm were deemed lower priority than actually getting the thing working. Look forward to these kinds of improvements in the future.

## The context switch

What is a *context switch* you ask? This is when a scheduler changes from executing one task to executing another. The "context" refers to all of the system state that needs to be present to execute a given task. What this consists of will depend on your architecture, but in most it will include your stack of runtime variables and CPU registers. During a context switch, we store the current task state onto its stack, change the stack pointer to look at the next tasks's stack, and then pop its state that was previously stored there. Note that each task (sometimes called a thread) has its own stack. It's cool that something as simple the stack pointer register can be so fundamental in enabling a multi-tasking OS. Imagine if it were read-only or hidden: the architecture would then only support one stack out of the box making multi-tasking more difficult.

# Implementation

## The task descriptor

The scheduler I've written maintains some state about each task which allows it to do this context switch. This state is stored in a task descriptor which themselves are stored in a circular queue. Take a look at the task descriptor struct below:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/scheduler.h?slice=15:20&footer=minimal"></script>

The most important member to note is `task_sp`. This member points to the task stack so that we can restore it when activating the task. In a more advanced scheduler, you might see additional information in the task descriptor, such as its priority or state.

## Implementing the context switch

### Timer setup

So then, what kicks off a context switch? In a cooperative scheduler, the currently running task would itself begin the process. In a preemptive scheduler, you usually need some sort of interrupt. For this project, I used a simple timer to do a context switch every one millisecond. When the timer fires, the CPU jumps into the interrupt service routine in which it performs a context switch. When we return from the interrupt, we'll find ourselves executing a different task than we were before. All it takes to set up the interrupt is the following:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/scheduler.c?slice=95:109&footer=minimal"></script>

`SCHEDULER_TICK_MS` is a constant which defines the period of the scheduler tick in milliseconds. This is set to 1 millisecond elsewhere. In just a few lines I've configured the timer to count up to the equivalent number of clock ticks and trigger an interrupt, repeatedly.

### The process of changing tasks

Now, let's take a look at the interrupt code -- the meat of the scheduler which manages our stacks:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/scheduler.c?slice=111:144&footer=minimal"></script>

At the top I declare `task_sp`, a file-scoped variable used later as a container for the stack pointer in some inline assembly code. It's important that it not be stack-allocated, as the stack is "under construction" in this function. It has to be file-scoped because for some reason, that's the only way to make it visible to the inline assembly -- I'd love for someone to tell me why that is.

Inside the timer interrupt function, I declare `task_ptr` static so as to not use the stack. This will point to the each of the tasks I'm switching between. My first step is to pop off the registers which the compiler wanted to push onto the stack at the beginning of this ISR -- no, no, compiler, don't worry, I've got this. Immediately after, I push ALL general purpose registers onto the stack and save the stack pointer into `task_sp`. I don't have to worry about the status register or program counter, as these were already pushed onto the stack when we jumped to the interrupt and will be popped again off when we return from it. If this context switch interrupted a task (`cur_task` is not `NULL`) then we should save the stack pointer back to the task desciptor to not lose track of it.

Next, we change the stack pointer to point at task #2's stack. Now any further stack operations will use its stack! I then proceed to pop off all the CPU registers stored on it during a previous context switch, and return from the interrupt. At this point, all state from when task #2 was halted has been restored.

And that's it for under the hood!

## API to the User

Another important consideration is the API provided to the user. In the case of an OS, the "user" is a programmer who wants to write software for the computer. My intent is to provide a strong knowledge barrier between tasks and the OS that runs them. Let's look at the functions available:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/scheduler.h?slice=22:46&footer=minimal"></script>

You've got an initialization function, a function to add a task, and finally one to kick off the scheduler. And there's a macro to make adding tasks even simpler. Let's see what that looks like in practice.

### What tasks actually look like

Here we see three different tasks that can all be scheduled:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/main.c?slice=28:49&footer=minimal"></script>

They each consist of some initialization code and an infinite while loop. In this way, they are written as though they have the processor all to themselves. There is no notion of yielding to other tasks.

### Example of tasks being scheduled

Here is those same tasks being scheduled:

<script src="https://gist-it.appspot.com/https://github.com/rjw245/rileyOS/blob/1.0.3/main.c?slice=19:28&footer=minimal"></script>

Behind the scenes, each call to the `SCHEDULER_ADD` macro statically allocates a stack of the requested size (in this case, 512 bytes each), pushes initial values onto it, and stores the stack pointer in a new task descriptor which gets queued up.

# End Result

And here's what it looks like when all those tasks are running at once!

![MSP430 Running the Scheduler](/assets/img/scheduler/msp430-running.gif)

Again, each LED and the screen are being controlled by independent while loops that need not cooperate explicitly. How cool is that!

# Future Work

It goes without saying that this scheduler is very simplistic. It's missing some basic features like OS support for sleeping, task prioritization, and semaphores for resource sharing to name a few. Maybe I'll implement some of these in version 2.0. For now, at least, I wanted to share this exploration of how schedulers work and how I implemented my own. I'd love to get feedback on this work -- I'm new at this so I'm sure there are things about my design/implementation that could be improved. Let me know what you think in the comments.

# Further Reading

If you want to learn more about OS design, a good book is [Micro C Os II](https://www.amazon.com/MicroC-OS-II-Kernel-CD-ROM/dp/1578201039){:target="_blank"}. If you want to take a closer look at my code, you can find it [on Github](https://github.com/rjw245/rileyOS/).
