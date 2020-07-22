---
layout: post
title: "Rust Traits: Defining Behavior"
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://oswalt.dev/assets/2020/07/rust-trait.png
date: 2020-07-22T00:00:00-00:00
tags:
  - 'rust'
---

Before jumping into any programming language, you often hear about its "heavy hitters" - the features that usually make the highlight reel when someone "in the know"
is trying to summarize the strong points of the language. In 2015, as I was learning Go, I would often hear things like concurrency support, channels, concurrency support, and Interfaces. Also concurrency support. With Rust, thus far the highlights have included things like strong support for generics, lower-level control, and an emphasis on memory safety manifested in the unavoidable ownership model.

Another that often comes up is a feature of Rust called "traits", and I've found it to be one of the more powerful - and enjoyable - aspects of learning Rust.

## What are Traits?

Often, when you're creating a set of functions for your own use, or maybe for a library you intend to publish for others to use, you don't want to be super rigid in defining what specific types are passed in. It's often useful to instead define a more abstract set of behaviors that you require, but allow the user of your function/library to create their own types that satisfy those constraints. I like to think of it as a bouncer that allows all kinds of different people into a nightclub, but only those that show good behavior.

<div style="text-align:center;"><a href="/assets/2020/07/bouncers.jpg"><img src="/assets/2020/07/bouncers.jpg" width="500" ></a></div>
<div style="text-align:center;font-size: 10px;">By <a href="//commons.wikimedia.org/w/index.php?title=User:Xxinvictus34535&amp;action=edit&amp;redlink=1" class="new" title="User:Xxinvictus34535 (page does not exist)">Xxinvictus34535</a> - <span class="int-own-work" lang="en">Own work (modified)</span>, <a href="https://creativecommons.org/licenses/by-sa/4.0" title="Creative Commons Attribution-Share Alike 4.0">CC BY-SA 4.0</a>, <a href="https://commons.wikimedia.org/w/index.php?curid=42012955">Link</a></div>

By the way, mechanisms for defining and/or enforcing behavior are not new concepts in Rust or any other language, for that matter. Java, for instance, has had ["interfaces"](https://www.tutorialspoint.com/java/java_interfaces.htm) for a long time. However, I spent the first several years of my career as a full-time developer writing almost exclusively in Python, which has no concept for this; Python's dynamic type model often means a ["duck typing"](https://realpython.com/lessons/duck-typing/) method of defining behavior is used, effectively moving the problem to runtime (which in retrospect still terrifies me).

So, I didn't have my first real experience with a compile-time behavior enforcement concept like this until I started learning Go. Go has the concept of [interfaces](https://gobyexample.com/interfaces), which in short, allows you to define a set of function signatures that a type must have in order to be considered as having implemented that interface. This allows you to accept interfaces in some of your higher-level functions instead of concrete types, which gives the user a bit more flexibility in what they pass in to those functions. As long as those types implement the functions defined by those interfaces, they'll work just fine.

Rust's equivalent is called ["traits"](https://doc.rust-lang.org/book/ch10-02-traits.html), and accomplishes much the same purpose. There are almost a billion articles on the basics of traits, so I'll be as brief as possible here. Just like in many languages, it's all about declaring a certain **behavior**, and like in many cases, what we're really talking about is the presence of a given function signature. For instance, in this simple example:

```rust
trait Speak {
    fn say_hello(&self) -> String;
}
```

We have a trait called "Speak", and that trait describes only a single function signature called "say_hello", which takes in a reference to `self` and returns a `String`. We haven't created any types yet, we've just declared this trait as a way of describing a behavior.

If we wanted to create a type called `Person`, and have it implement this trait, we would need to create a function within a special `impl` block that says we're intending to implement the `Speak` trait, and then ensure that we've created the right functions (including parameters and return types) required by the trait:

```rust
struct Person {}

impl Speak for Person {
    fn say_hello(&self) -> String {
        String::from("Hello!")
    }
}
```

In this example, the `Person` type is said to have implemented the `Speak` trait. We know this because if it didn't, it wouldn't even compile (one of the cooler parts of the way Rust does things here, which I'll get to later). The workflow here is two-part; we first describe the behavior as a trait, and then implement that behavior in a concrete type.

## Trait Default Implementations

Rather than forcing all types to implement traits on their own, traits can be created with [default implementations](https://doc.rust-lang.org/book/ch10-02-traits.html#default-implementations) that structs can simply use, or override as needed. This is especially useful if you have a bunch of different types, and you wish them to all have some kind of shared behavior, without wearing out your copy+paste shortcuts.

```rust
trait Speak {
    // This is the default implementation of the say_hello function
    fn say_hello(&self) -> String {
        String::from("Hello!")
    }
}

// Person1 and Person2 simply use the default implementation, and don't
// have to redefine it
struct Person1 {}
impl Speak for Person1 {}
struct Person2 {}
impl Speak for Person2 {}

// Person3 can redefine the say_hello function, provided it follows the
// signature required by the trait
struct Person3 {}
impl Speak for Person3 {
    fn say_hello(&self) -> String {
        String::from("Hello World!")
    }
}

fn main() {
    let p1 = Person1{};
    println!("{}", p1.say_hello());
    let p2 = Person2{};
    println!("{}", p2.say_hello());
    let p3 = Person3{};
    println!("{}", p3.say_hello());

    // Output:
    //
    //  Hello!
    //  Hello!
    //  Hello World!
}
```

In my experience, default implementations are most useful when I am creating the trait and the types that use that trait's implementation. This is a way of reducing unnecessarily duplicated code, primarily. The vast majority of the times I've seen traits as part of an external crate's (library) API, it required me to provide implementations for them, as a way of forcing me to really define how I expect that behavior to be expressed in my codebase.

> This makes a lot more sense if you think of things from the perspective of an API builder. If you're building an API, in some cases you may not want to restrict users to using only a few predefined types, but you also can't allow the wild west, because you still need to rely on at least some kind of expected behaviors. In this case, your API can accept any types that implement a certain trait(s). This allows users to build their own types, but still require that they fully implement your traits in a way that's locally relevant to those types. In plain language: "you can pass me anything you want as long as it has this behavior, and you have to figure out how it gets that behavior".

This leads into the use of traits as function parameters, and the "trait bound" syntax.

## Traits as Parameters, and the Trait Bound Syntax

At this point, you might be asking - "Why is this useful? I mean, why don't we just drop the trait bits and just declare this method under a regular old `impl Person` block?"

As alluded to at the end of the previous section, the primary reason we focus on defining and then implementing certain behavior, is that we can then build APIs that are behavior-centric, and not just type-centric. Rather than building functions that only accept a certain, predefined type, we can build functions that instead allow **any** type to be passed in, provided they implement a certain behavior, or set of behaviors. In other words, you can use Traits in the place of concrete types, such as in [function parameters](https://doc.rust-lang.org/book/ch10-02-traits.html#traits-as-parameters):

```rust
fn give_greeting(p: impl Speak) {
    println!("{}", p.say_hello());
}
```

The `impl` keyword is used here to say that the parameter `p` should be some kind of type that implements the `Speak` trait.

> For what it's worth, I don't like this syntax. I mean, I've seen similar keywords used in function parameters before to provide additional details about it (the `mut` keyword comes to mind), but this syntax still feels strange to me. I'm not sure if it's the re-use of the `impl` keyword or what, but something about this still doesn't sit right for some reason. I think the idea is that the `impl` syntax makes things a little easier to read for simple cases, but in my experience working with several third-party libraries, this syntax is rarely used. So while it may be useful to remember this syntax in the back of your head just in case, it seems to me that the following "trait bounds" syntax as explained below is the more practical format to learn and use.

It turns out that this is just syntactic sugar for what's **really** going on, which is called [trait bounds](https://doc.rust-lang.org/book/ch10-02-traits.html#trait-bound-syntax).  The above function can be re-written with the "full" trait bound syntax thusly:

```rust
fn give_greeting<T: Speak>(p: T) {
    println!("{}", p.say_hello());
}
```

In this case, we're defining a **generic** type `T`, which must implement the `Speak` trait. This is what's within the `<...>` portion of the function signature. Once defined, we can just specify that the parameter `p` needs to be of type `T`.

> This starts to allude to the use of Generics in Rust, which, given my path through Python and Go, I actually don't have a lot of practical experience with. We'll get into much more detail on generics in future posts, but the use of generics as function parameters is a place where trait bounds becomes immensely useful.

If the multiple syntaxes for using traits for function parameters hasn't totally confused you yet, there's yet another alternate syntax for trait bounds [using the `where` keyword](https://doc.rust-lang.org/book/ch10-02-traits.html#clearer-trait-bounds-with-where-clauses), which becomes especially useful when there are a lot of generic type parameters. Rewriting this example again:

```rust
fn give_greeting<T>(p: T)
    where T: Speak
{
    println!("{}", p.say_hello());
}
```

Here, the declaration of T (as `<T>`, just before the parentheses) is still required, but the binding to the `Speak` trait is handled on its own line. If we had multiple generic parameters that needed their own similar bindings, this would be a lot clearer to follow than the previous syntax.

Looking back at some of the times I've tried to read Rust code to get a better understanding, these syntaxes have been the source of some of the most confusion, but that was purely because of my own ignorance. Now that I'm aware of this, I feel like I am **much** better able to read third-party code that makes judicious use of the trait bound syntax.

A recent example of this was in my current project, where I was looking to integrate Rust and Lua using the [`rula` crate](https://crates.io/crates/rlua). I wanted to be able to define a set of Lua types that could be translated into Rust types. `rlua` allows for this, and uses traits like [FromLua](https://docs.rs/rlua/0.10.2/rlua/trait.FromLua.html) to require me to perform the necessary translations from Lua-land to Rust-land. If I don't implement this trait on the Rust types that I intend to make available to Lua scripts, then certain things won't work, such as [the creation of Lua functions](https://docs.rs/rlua/0.14.0/rlua/struct.Lua.html#method.create_function) that run in Rust as a sort of FFI. Note the use of the `where` syntax for the `create_function` method; the traits referenced there are what requires me to get my things in order before trying to use it.

Some other interesting tidbits while we're talking about traits and functions:

- You can [require that a generic parameter implements multiple traits](https://doc.rust-lang.org/book/ch10-02-traits.html#specifying-multiple-trait-bounds-with-the--syntax), using the `+` sign. This applies to the regular trait bound syntax, or using the `where` keyword.
- [Return types](https://doc.rust-lang.org/book/ch10-02-traits.html#returning-types-that-implement-traits) can also be traits.

## Rust Explicit Trait Enforcement

When working with behavior describing/enforcing features like traits, often the biggest question is how they'll be enforced. Most languages allow behavior to be declared (Rust in traits, Go/Java/etc in "interfaces"), but how/when those behaviors are enforced can vary.

For instance, in Go, we define behavior with "interfaces". These are enforced implicitly when you try to use a type in a place (like a function parameter) that accepts an interface. If you have a field that accepts an interface type, and you pass in something that doesn't conform to that interface, you get an error. Like Rust, this is checked at compile time. However, because this check is implicitly performed **on use**, it's possible that you could have code that you **think** implements a certain interface, but if you're not using it anywhere, this isn't checked.

```go
package main

import "fmt"

type Speak interface {
	sayHello() string
}

type Person struct {
}

// This function has a different return type than required by the "Speak" interface
// so the "Person" type doesn't currently satisfy it.
func (p Person) sayHello() int {
	return 42
}

func main() {
  // Compliance with the interface "Speak" is only checked if we try to use the
  // Person type as a parameter to the "give_greeting" function as below.
  //
  // The code as-is will compile just fine, but if we un-comment the below,
  // it will fail to compile because the type we're trying to pass to give_greeting
  // doesn't satisfy the "Speak" interface.
  //
  // p := Person{}
  // give_greeting(p)
}

func give_greeting(p Speak) {
	fmt.Println(p.sayHello())
}
```

I can imagine some cases where I might be building an API with some default types, but not actually passing those types into my API functions myself - in this case I'd be expecting the user to do something with those types, and **then** pass them into a function of some kind. It's important that I know these types actually implement the interface, and how will I do that if I'm not actually using them, in order to get this implicit enforcement?

> The most obvious answer is that you should of course be writing tests to do everything you expect your users to do, which would require you to create a given type that satisfies an interface, and then actually using that type in your API. So, this is definitely not an un-solvable problem in Go. However, it's an interesting look at the different ways things are done in different languages.

With Rust, the enforcement is more explicit; even if you don't try to use a given type where a trait is accepted, just the act of trying to implement that trait on that type triggers the Rust compiler to check for full compliance. This earlier example includes our `Speak` trait, and a type `Person`, which, given the `impl Speak for Person` phrase, is **automatically** checked for compliance, even if no instance of `Person` is created or used:

```rust
trait Speak {
    fn say_hello(&self) -> String;
}

struct Person {}
impl Speak for Person {
    fn say_hello(&self) -> String {
        String::from("Hello!")
    }
}
```

As long as our program compiles, we **know** the trait is implemented correctly. We can put this to the test by simply changing the return type of the function to force it to be non-compliant with the `Speak` trait. The type `Person` is not used anywhere, and its `say_hello` function is otherwise syntactically correct, but since `Speak` is no longer implemented properly, this code will not compile:

```rust
trait Speak {
    fn say_hello(&self) -> String;
}

struct Person {}
impl Speak for Person {
    fn say_hello(&self) -> usize { // <-- doesn't compile!
        42
    }
}
```

I like this model because there's no ambiguity there. Rust literally won't compile unless a type actually implements the trait properly, regardless of whether or not you try to use that type anywhere. What's more, is this has to be done completely. Once you introduce the `impl <trait> for <type>` statement, you must define all of the functions required by the trait before your code will compile again. There's no partial implementation.

This explicit way of doing things is definitely in-line with the Rust attitude I've been learning these few months. Just because your code compiles doesn't guarantee that it will work, but in Rust, the compiler does a whole hell of a lot to keep you from doing the sillier stuff, which is a win in my book.


## Rust Polymorphism using Trait Objects

If you come from dynamic languages like Python, you're used to being able to do things like store many different types in a list. A Python list could have an integer, then a string, then a class, then a class instance, and on and on. Python has no rules, all is chaos. Indeed, this is a big struggle point if you're new to Rust, or static languages in general, where simple collection types (like [Rust's "vector"](https://doc.rust-lang.org/book/ch08-01-vectors.html), or Go's "slice") must be declared with a certain type, and all members of that collection must be of that type. This vector `v` is declared with the type `i32`, and only values of this type can be pushed to `v`:

```rust
let mut v: Vec<i32> = Vec::new();
```

Remember how in the previous sections, we used traits to create functions that cared less about the specific types being used, but rather focused on the **behavior** those types exhibited? This gave us a lot of flexibility in the concrete types we were able to pass in to a function. Any type was okay provided it implemented the trait(s) we required.

It turns out, we can use the same kind of tactic to bring this flexibility to collections like vectors. What if we wanted a vector that was not defined by a single concrete type, but rather was able to contain any type that implemented a given trait? This is possible through something called "[trait objects](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)".

> Before getting too deep, I want to mention that there is a trade-off when using trait objects. Generally, a lot of abstractions within Rust (including traits in general) are referred to as "zero-cost" abstractions (**please** watch [this video](https://www.youtube.com/watch?v=Sn3JklPAVLk&feature=emb_title) if you want to know more about this term). This means that as much as possible, Rust tries to let you write really expressive, maintainable code, without forcing you to take a performance penalty at runtime for the privilege. However, trait objects are an exception. Because of the way that trait objects leverage [dynamic dispatch](https://en.wikipedia.org/wiki/Dynamic_dispatch) behind the scenes in order to look up a given method on that trait object that is called at runtime, there is a little bit of a performance hit. The tradeoff here seems to be that you end up with much more readable and maintainable code; you are on the hook for evaluating if the performance hit is too much. For more, I'd recommend [this page on the `dyn` keyword](https://doc.rust-lang.org/std/keyword.dyn.html) - it explains this tradeoff quite well.

When we created the vector `v` above, we declared it as type `i32`. Again, this means that any value we push to it must be an `i32`. If you consider using our `Speak` trait in lieu of a concrete type, you may be tempted to amend this to something like:

```rust
let mut v: Vec<Speak> = Vec::new();
```

However, this won't work:

```
error[E0277]: the size for values of type `dyn Speak` cannot be known at compilation time
   --> src/main.rs:41:16
    |
41  |     let mut v: Vec<Speak> = Vec::new();
    |                ^^^^^^^^^^ doesn't have a size known at compile-time
```

This error message is obvious if you think about it - if we're only enforcing based on behavior, Rust has no idea what size to allocate for the elements of this vector. In contrast, types like `i32` have a well-known, predictable size.

The correct way to create a vector of trait objects is the following syntax:

```rust
let mut v: Vec<Box<dyn Speak>> = Vec::new();
```

This introduces two new concepts we should briefly touch on before proceeding:

- The `Box` keyword actually refers to the [Box](https://doc.rust-lang.org/book/ch15-01-box.html) type, which is part of Rust's standard library, and is referred to sometimes as a "smart pointer".  It is used specifically when you would like to have a consistently-sized reference to a value, but have that value itself actually allocated on [the heap](https://gribblelab.org/CBootCamp/7_Memory_Stack_vs_Heap.html). Using it within the context of trait objects means Rust now knows the size of each element of the vector - namely, the size required by the Box pointer, regardless of the value that pointer represents. This gets us past the error we just saw.
- The [`dyn` keyword](https://doc.rust-lang.org/std/keyword.dyn.html) is an easy way to know if something is being declared as a trait object, because it is now the required way of identifying them (previously, this keyword was implied, but as of the time of this writing, trait objects without an explicit `dyn` is deprecated). It alludes to the idea that methods on trait objects are called via dynamic dispatch as mentioned earlier.

Knowing this, the use of trait objects becomes fairly straightforward. First, we'll redefine our familiar trait `Speak` with a default implementation, and create a few structs that use this implementation as-is:

```rust
trait Speak {
    fn say_hello(&self) -> String {
        String::from("Hello!")
    }
}

struct Person1 {}
impl Speak for Person1 {}
struct Person2 {}
impl Speak for Person2 {}
struct Person3 {}
impl Speak for Person3 {}
```

Then we can create a `Crowd` struct that has a field `speaking_people` which is where we'll put our vector. Because we're using trait objects, our `main()` function can call the `say_hello()` function for each iteration of the vector, even though the underlying types are totally different!

```rust
struct Crowd {
    // We're creating our trait object with `dyn Speak`, and wrapping it
    // in a Box, so we can understand at compile-time, the size of the elements of
    // our vector.
    speaking_people: Vec<Box<dyn Speak>>,
}

fn main() {
    let crowd = Crowd {

        // Note that we're using three different types in this vector!
        // Trait objects are bonkers.
        speaking_people: vec![
            Box::new(Person1 {}),
            Box::new(Person2 {}),
            Box::new(Person3 {}),
        ],
    };
    for person in crowd.speaking_people.iter() {
        println!("{}", person.say_hello());
    }
}
```

## Additional Resources

There are a few "official" links you're bound to run into if you start googling on traits like I did, so here's a quick list:

- [Rust Book Chapter 10.2 - Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [Rust Book Chapter 17.2 - Trait Objects](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)
- I didn't even cover the **really** advanced stuff. If you want to dive down the rabbit hole, check out [Rust Book Chapter 19.3 - Advanced Traits](https://doc.rust-lang.org/book/ch19-03-advanced-traits.html)
- ["Rust by Example" book chapter on traits](https://doc.rust-lang.org/rust-by-example/trait.html)

If the above was a big TL;DR and you're instead interested in a **whirlwind tour**, this talk was good, short, and clearly well-rehearsed:

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/grU-4u0Okto" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
