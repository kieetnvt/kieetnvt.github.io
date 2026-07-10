---
layout: post
title: "Concurrency, Parallelism, and Async: Three Ideas That Sound Similar"
subtitle: How modern software handles multiple tasks without confusing the tools
cover-img: /assets/img/codebg.webp
thumbnail-img: /assets/img/codebg.webp
share-img: /assets/img/codebg.webp
tags: [programming, concurrency, parallelism, async, ruby, system-design]
author: kieetnvt
---

Every developer has heard the words **concurrency**, **parallelism**, and **async**.

Many developers also use them as if they mean the same thing.

They do not.

All three ideas answer a similar surface-level question:

> How can my program handle more than one thing?

But they answer it at different layers. Concurrency is about structure. Parallelism is about execution. Async is a programming model for avoiding wasted waiting time.

Confusing them can lead to poor architecture decisions, unnecessary threads, surprising bugs, and performance work that does not move the bottleneck.

Let's separate them clearly.

## The Kitchen Analogy

Imagine a chef preparing a three-course dinner.

She starts boiling pasta, then chops vegetables while the water heats. That is **concurrency**: multiple tasks are in progress, but she is still one person switching between them.

If the restaurant hires another chef who prepares the salad at the same time, that is **parallelism**: two people are truly working simultaneously.

If the chef puts something in the oven, sets a timer, and serves another table instead of staring at the oven, that is the basic idea behind **async**: do not block while waiting.

Same kitchen. Different strategies.

## Concurrency: Juggling Work

Concurrency means multiple tasks are **in progress** during the same period, but they are not necessarily executing at the exact same instant.

On a single CPU core, only one instruction runs at a time. The operating system can still make multiple tasks appear active by switching between them quickly. This is called **time-slicing** or **context switching**.

From the outside, it can look like everything is happening at once. Under the hood, tasks are taking turns.

Concurrency is useful when tasks spend time waiting:

- reading files
- querying a database
- calling external APIs
- waiting for a cache
- handling many web requests

These are usually **I/O-bound** tasks. The CPU is not busy the whole time. It spends much of the time waiting for something else.

Concurrency lets the program make progress on other work during those waits.

## Parallelism: Truly Running at the Same Time

Parallelism means multiple tasks execute **at the exact same time**, usually on different CPU cores.

There is no turn-taking. If you have two cores, two pieces of work can run simultaneously. If you have eight cores and the problem can be split cleanly, more work can happen at once.

Parallelism is useful for **CPU-bound** tasks:

- image processing
- video encoding
- compression
- matrix multiplication
- machine learning inference
- large data transformations

These tasks spend most of their time using the CPU directly. If the work can be divided into independent chunks, parallelism can reduce wall-clock time.

But parallelism has a cost.

## The Price of Parallelism

Parallel code often introduces shared-state problems.

If two cores read and write the same memory at the same time, the result may depend on timing. That is a **race condition**.

To prevent race conditions, you may need mutexes, semaphores, atomics, queues, immutable data, or actor-style isolation. These tools work, but they add complexity. Locks can also become bottlenecks through **lock contention**, where many workers spend time waiting for permission to access the same resource.

This is why "make it multi-threaded" is not a performance strategy by itself. Parallelism helps only when:

- the work is CPU-bound
- tasks are independent enough
- there are available cores
- coordination overhead is lower than the saved work

If those conditions are not true, parallelism can make a system slower and harder to reason about.

## Async: Waiting Without Blocking

Async is a programming model for handling waiting efficiently.

The key idea is simple: when a task has to wait for I/O, do not block the thread. Register the waiting operation, let the runtime do other work, and resume the task when the result is ready.

In many runtimes, this is coordinated by an **event loop**.

For example, imagine a request handler needs a user record and an order list. A blocking version might do this:

1. Ask the database for the user.
2. Wait.
3. Ask the database for the orders.
4. Wait.
5. Build the response.

An async version can start both waits and resume when the data arrives. The total wait time is closer to the slower of the two operations instead of the sum of both waits.

That is the efficiency gain: async keeps the thread from sitting idle.

Async does not mean parallel. A single-threaded event loop can handle many tasks concurrently, but only one piece of code executes at a time on that thread.

## A Small Ruby Example

Ruby fibers are a useful way to understand cooperative concurrency. This example is simplified, but it shows the shape of pausing and resuming work:

~~~ruby
fetch_user = Fiber.new do
  puts "Fetching user..."
  Fiber.yield "User: Alice"
end

fetch_orders = Fiber.new do
  puts "Fetching orders..."
  Fiber.yield "Orders: [#1, #2, #3]"
end

user = fetch_user.resume
orders = fetch_orders.resume

puts user
puts orders
~~~

In real applications, async runtimes coordinate I/O readiness, scheduling, and resuming tasks. The important idea is that work can pause at known points and continue later, without blocking an entire thread during the wait.

## How the Three Ideas Relate

The clean mental model is:

- **Concurrency** is about structure: multiple tasks can make progress during the same period.
- **Parallelism** is about execution: multiple tasks physically run at the same time.
- **Async** is a technique for concurrency: tasks pause while waiting and resume later.

They are not mutually exclusive.

A web server may use async I/O to handle many connections. It may use a thread pool for blocking libraries. It may send CPU-heavy jobs to worker processes that run in parallel across cores.

Real systems often combine all three. The key is knowing which layer you are dealing with.

## A Decision Framework

When facing a performance or scaling problem, ask these questions before reaching for threads, async, or worker pools.

### 1. Is the bottleneck CPU or I/O?

Profile first.

If most time is spent waiting for databases, caches, files, or HTTP calls, you are probably dealing with an I/O-bound problem. Concurrency or async may help.

If most time is spent calculating, encoding, parsing, compressing, or transforming data, you are probably dealing with a CPU-bound problem. Parallelism may help.

### 2. How many tasks need to be active?

Dozens of threads may be fine.

Thousands of connections may be expensive if each one needs a dedicated thread. In that case, async I/O or lightweight concurrency primitives can be a better fit.

### 3. Do tasks share state?

Shared mutable state is where many bugs live.

If tasks need to update the same data, parallelism becomes harder. You need locking, queues, atomic operations, immutable data structures, or isolation.

If the work can be made independent, the design becomes much safer.

### 4. What does your runtime support well?

Different languages have different strengths.

Node.js is built around async I/O. Go has goroutines and channels. Ruby MRI has a Global VM Lock, so Ruby threads are great for I/O-bound concurrency but not for CPU-bound parallel Ruby execution. Ruby 3 introduced Ractors for isolated parallel execution.

Use the model your runtime supports well before forcing another one into it.

## Ruby as a Practical Example

Ruby is a good lens because it shows the difference clearly.

MRI Ruby has a **Global VM Lock**. Only one Ruby thread executes Ruby code at a time. That means Ruby threads do not give CPU-bound Ruby code true parallelism.

But Ruby threads can still be very useful for I/O-bound web applications. During many I/O waits, the runtime can release the lock and let another thread make progress.

Ruby 3 introduced **Ractors**, which allow true parallel execution with isolated state. Ractors avoid shared mutable memory by communicating through message passing. That makes them safer for parallelism, but also stricter than ordinary objects and threads.

Async Ruby libraries use fibers and event loops to make waiting cheaper. This can let one process handle many I/O-heavy tasks without creating a thread for every request.

The point is not that one model wins. The point is that each model solves a different problem.

## Amdahl's Law: The Limit of Parallel Speedup

Before parallelizing everything, remember Amdahl's Law.

If only part of your program can run in parallel, the sequential part limits the total speedup. The simplified formula is:

~~~text
speedup = 1 / ((1 - p) + (p / n))
~~~

Where:

- `p` is the fraction of the program that can be parallelized
- `n` is the number of processors

If half your program is inherently sequential, even infinite processors cannot make the whole program more than twice as fast.

This is why profiling matters. Parallelizing the wrong part of a system creates complexity without meaningful speedup.

## Common Misconceptions

**"Multithreading always makes things faster."**

Only if the work benefits from it. I/O-bound work may need better concurrency, not more CPU parallelism. Shared-state threads can also add overhead.

**"Async means parallel."**

No. Async can let many tasks make progress on one thread, but only one piece of code runs at a time on that thread.

**"Concurrency is always dangerous."**

Not always. Shared mutable state is dangerous. Single-threaded async, message passing, queues, and immutable data can make concurrent systems much easier to reason about.

**"Ruby threads are useless because of the GVL."**

Not for I/O-bound work. Most web applications wait on databases, caches, and network calls. Ruby threads can still improve throughput for that kind of workload.

## The Practical Takeaway

Use the terms precisely:

- Use **concurrency** when you mean multiple tasks are in progress.
- Use **parallelism** when you mean multiple tasks execute at the same time.
- Use **async** when you mean a task can wait without blocking the thread.

For I/O-bound systems, focus on concurrency and non-blocking waits.

For CPU-bound systems, look for independent work that can run in parallel.

For shared-state systems, design the data flow carefully before adding more workers.

Most scalable systems use a mix of all three. The difference between a clean design and a fragile one is knowing which tool solves which bottleneck.
