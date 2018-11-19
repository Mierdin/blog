---
layout: post
title: Double Parentheses in Python
author: Matt Oswalt
comments: true
categories: ['Code']
date: "2015-05-23"
slug: python-double-parentheses
tags: ['python']
---


Python is one of the easiest programming languages to learn, because of it's inherent flexibility. (This can be a good thing as well as a bad thing.)

One example of Python's flexibility is the double parentheses. Take the following snippet for example:

	print funcwrapper(3)(2)

Even an inexperienced programmer should be able to make sense of most of this. Reading from left to right, it looks like we want to print the output of a function, and we're passing an integer - 3 - to that function. However, the second pair of parentheses doesn't quite make sense.

This notation is different from what we would do if we wanted to pass two arguments to a function; in that case, we'd put them all inside a single pair of parentheses and separate them via commas:

	print funcwrapper(3, 2)

So what does the first example using two pairs of parentheses accomplish?

The use of a double parentheses is actually an indicator of one of Python's coolest features - and that is that _functions are themselves, objects!_ What does this mean?

Let's work our way up to the snippet above by first defining a very simple function - something that 
takes an integer as an argument, adds one to it, and returns the result. Pretty simple:

{{< highlight python >}}
>>> def addone(x):
...     return x + 1
...
>>> result = addone(2)
>>> print result
3
{{< /highlight >}}

Our output is an integer, with a value of 3.

However, let's try to do something a little more interesting. What if we embed this "addone" function within  a wrapper function, that throws a second integer into the mix?

{{< highlight python >}}
>>> def funcwrapper(y):
...     def addone(x):
...         return x + y + 1
...     return addone
...
>>> result = funcwrapper(3)(2)
>>> print result
6
{{< /highlight >}}

You can see that we're calling the wrapper function with the double parentheses. This is possible because our wrapper function actually returns object representing the addone function, not it's result.

> This is because (on line 4), we are returning "addone", not "addone()"

In sequence, "funcwrapper(3)" is evaluated first, and it returns the "addone" function itself. Because the first parameter (y) is set to 3, the function that is returned will end up evaluating x + 3 + 1.

Because we have a second pair of parenthesis (2), this ends up being the parameter to the embedded "addone" function, which means that x is set to 2.

Therefore, 2 + 3 + 1 = 6.

> As pointed out [in the comments](https://keepingitclassless.net/2015/05/python-double-parentheses/#comment-2069279567) - this whole concept is commonly referred to as a "closure", and it is most often used to implement decorators.