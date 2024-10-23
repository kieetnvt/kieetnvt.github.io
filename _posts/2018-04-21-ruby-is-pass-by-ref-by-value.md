---
layout: post
title: Ruby is pass-by-value, but the values it passes are references
subtitle: Ruby is pass-by-value, but the values it passes are references
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby]
author: kieetnvt
---


# Ruby is pass-by-value, but the values it passes are references.

## The variable is not the object, variable is a "box" that point to the object

exmaple: a = []

a is a variable, refer to the array object. it not a array itself.
a is "box", contain the array

## Pass-by-reference

the box (the variable) is passed directly into the function
refer to the exact same object in memory for variable in function context and for the caller.

=> Pass-by-reference --> reference to exactly memory of object --> varable will be change

## Pass-value-by-value

In pass-value-by-value, the function receives a copy of the argument objects passed to it by the caller,
stored in a new location in memory.

The copies of variables and objects in the context of the caller are completely isolated. `*(variable will not change)`

## Pass-reference-by-value

> Ruby is pass-by-value, but the values it passes are references.

Ruby acts like pass by value for immutable objects, pass by reference for mutable objects is a reasonable answer
Immediate values are not passed by reference but are passed by value: nil, true, false, Fixnums, Symbols, and some Floats.

