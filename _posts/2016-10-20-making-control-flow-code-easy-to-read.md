---
layout: post
title: "The art of readable code: Making control flow easy to read"
subtitle: "The art of readable code: Making control flow easy to read"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/readablecode.jpg
share-img: /assets/img/path.jpg
tags: [nginx webserver]
author: kieetnvt
---


# Making control flow to easy to read.

## I. Make conditional, loops, other changes to control flow as "Natural" as possible.

Example:

```
if(tuoi_cua_em >= 18) or if(18 >= tuoi_cua_em)

while(tuoi_cua_em <= 18) or while(tuoi_cua_em >= 18)
```

Why first version is more readable ???

Assume we have: A > B

Left hand side (A): Many cases It is a value to be checked, It is changed follow by time, It is variable.

Right hand side (B): It is a stable value, It is a value to be checked with A. Many cases It is a constant.

## II. The order of IF/ELSE block.

Example:

```
if (a == b) {
  <!-- doing job A -->
} else {
  <!-- doing job B -->
}

OR

if (a != b) {
  <!-- doing job B -->
} else {
  <!-- doing job A -->
}
```

The first version is simpler to understand. It near natural says.

Prefer dealing with POSSITIVE CASE FIRST, instead of Negative (if (debug) more readable than if(!debug))

Prefer dealing with SIMPLE CASE FIRST.

Prefer dealing with the more INTERESTING CASE or SPECIAL CASE or DANGEROUS CASE FIRST.

## III. The ? condition.

Instead of You minimizing the number of lines of code, a better metric is to MINIMIZE THE TIME NEEDED OF SOMEONE TO UNDERSTAND YOUR CODE.

Example:

```
result = ((a > b) ? c : ((a == b) ? d : ((a - b == 1) ? f : g)))

OR

result = if (a > b) {
  c
} elsif (a == b) {
  d
} elsif (a - b == 1) {
  f
} else {
  g
}
```

The second version take less time to understand than version 1.

## IV. Avoid DO..WHILE loops.

```
do {
  if (A) {
    do job A
  }
} while (B)
```

As natural, you read the code from TOP -> to BOTTOM (Top-Down code readable). You always look condition A at first. But in DO..WHILE loops, The condition B must be read first. It so dangerous.

## V. Return early from a function.

When you write down a Function, you should deal with the special case first to return early functions.

Also, you should deal with cases easy first => That make your code clear and clean, avoid complicated, descrease bugs.

```
def string_contains(str, sub_str)
  return false if str.nil? || sub_str.nil?
  return true if sub_str == ""
  ....
end
```

## VI. Minimize Nesting IF/ELSE

Nesting IF/ELSE make lot of time to understand => You can remove Nesting IF/ELSE by Return Early Function.

## VII. Break down GIANT EXPRESSION.

Use Explain variables to capture small expression.

```
if(line.split(":")[0].strip() == root()) {
  doSomeThing(line.split(":")[0].strip());
  updateName(line.split(":")[0].strip());
}

OR

user_name = line.split(":")[0].strip();

if (user_name == root()) {
  doSomeThing(user_name);
  updateName(user_name);
}
```

Use summary variables

```
if (request.user.id == document.owner_id){
  <!-- do A -->
}
if (request.user.id == document.owner_id){
  <!-- do B -->
}

OR

var user_owns_document = request.user.id == document.owner_id;
if (user_owns_document) {
  <!-- do A -->
}
if (user_owns_document) {
  <!-- do B -->
}
```

## VIII. Use DE MORGAN LAWS

Use De Morgan Law to resolve complicated giant expression.

De Morgan Law says:

```
not (A or B or C) <=> (not A) and (not B) and (not C)

not (A and B and C) <=> (not A) or (not B) or (not C)
```

Example:

```
if (!(file_exists && !is_protected)) Error("Sorry, could not read file.");

OR

if (!file_exists || is_protected) Error("Sorry, could not read file.");
```

You should apply De Morgan Law to your code, to simplify giant expression.

_Next blog in The art of readable series, I will show you about "Reorganizing Your Code" and "Turning Thoughts into Your code". Keep in touch with me. Many thanks._