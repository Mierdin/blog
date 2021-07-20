---
layout: post
title: "Using Generic Types in Rust"
author: Matt Oswalt
comments: true
categories: ['Programming']
featured_image: https://oswalt.dev/assets/2021/06/generics_snippet.png
date: 2021-06-15T00:00:00-00:00
tags:
  - 'rust'
---

[In a prior post](https://oswalt.dev/2020/08/what-is-generic-programming/), I explored "generic programming" with the aim of highlighting the language-agnostic benefits and core concepts. Especially if this is a new topic for you, I encourage you to read this post first, as there are a lot of ideas covered there that apply much more broadly than what we'll get to in this post, which instead will focus on how Rust does things.

In this post we'll get into some specifics, and specifically look at how, together, **generic types** and **traits** form a powerful combination of tools in Rust that allows us to be productive and expressive, without sacrificing the inherent predictability and safety of a statically typed language.

> I have found existing Rust libraries and APIs **much** easier to understand now that I've tackled these two topics. I really struggled to read Rust code before I spent some extra time understanding not only generics and traits in rust, but the concepts they represent and their underlying implementation. If this is a struggle for you too, hopefully this series of posts will help.

As I covered in the [previous post](https://oswalt.dev/2020/08/what-is-generic-programming/), to enable the developer to make use of generic programming, a language must provide two things:

- A syntax that allows the developer to use generic terms as placeholders for more concrete types to be passed in elsewhere
- An underlying implementation that allows generic terms to be rendered to concrete terms when appropriate

In this post, we'll cover the syntax for using generics in Rust, with some practical examples. We'll cover the underlying implementation in an upcoming post, as Rust provides some interesting choices with respect to polymorphism that have implications here.

# Type Parameters

If you've been using Rust for even a small amount of time, you've likely made use of generics without realizing it. Take the simple example of creating a new vector:

```rust
let myvec = Vec::new();
```

This code will not compile; we haven't provided the [type parameter](https://bluejekyll.github.io/blog/rust/2017/08/06/type-parameters.html) indicating what type this vector should contain.

```
error[E0282]: type annotations needed for `std::vec::Vec<T>`
 --> src/main.rs:7:17
  |
7 |     let myvec = Vec::new();
  |         -----   ^^^^^^^^ cannot infer type for type parameter `T`
  |         |
  |         consider giving `myvec` the explicit type `std::vec::Vec<T>`, where the type parameter `T` is specified
```

This is because the [implementation for vectors](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.new) requires a generic parameter `T`, which is a placeholder that we must fulfill with a specific type.

```rust
// We can provide the type parameter on creation
let myvec: Vec<i32> = Vec::new();

// Or, we can add to the previous example by making our vector mutable,
// and then pushing elements to it.
let mut myvec = Vec::new();
// The compiler will automatically infer the inner type of the vector using the type of
// the pushed element.
myvec.push(34);
```

Either of the above approaches work - the important thing is that the compiler needs to know at some point which concrete type you intend to use to replace the placeholder `T`.

> It's important to understand that this is NOT the same as dynamic typing. Dynamic typing is a concept in much more runtime-oriented languages like Python that involves being able to change the type for any variable at **runtime**, or creating collections/arrays of multiple different types. This is not possible in Rust.

Now, we'll explore how to make use of Generics to define placeholders like this in your own Rust code.

# Defining Generic Types in Rust

Rust can make use of generics in several places:

- Function Definitions
- Struct Definitions
- Enum Definitions
- Method Definitions

> Examples of each of these are documented well in the [Rust book](https://doc.rust-lang.org/book/ch10-01-syntax.html), so if you're looking for complete examples of each, please refer there. I'll highlight a few things that stuck out to me.

Regardless of how they're used, they fulfill a simple purpose - allowing the developer to write more concise, less duplicate code. As we explored in the [previous post](https://oswalt.dev/2020/08/what-is-generic-programming/) more broadly, in the absence of generics, we are forced to either write a lot of duplicate code that allows for the use of different concrete types, or rely on tools available at runtime which may incur significant performance penalties or create error conditions that we have to go the extra mile to handle properly.

With generics, we are able to bypass this choice. Instead we get to write our code concisely, and allow the compiler to do the work of converting all of our "placeholders" into concrete, static types that gives us the speed and safety we need.

A simple illustrative example is warranted. Without generics, if we wanted to represent a two-dimensional point in space, we'd have to make sure we had a struct to represent this for any concrete type we'd want to use as the coordinate values:

```rust
struct PointI32 {
    x: i32,
    y: i32,
}

struct PointF32 {
    x: f32,
    y: f32,
}
```

With generics, however, we need only write one instance of this struct, and use a "placeholder" to indicate that we want the type to be provided on instantiation, just like we saw above with the vector example.

```rust
struct Point<T> {
    x: T,
    y: T,
}
```

When Rust compiles this code, it will analyze how this struct is used, and will ["monomorphize"](https://rustc-dev-guide.rust-lang.org/backend/monomorph.html) it. This is a process of creating duplicates of these types but with concrete types, instead of generic types. This allows us as developers to write the simple generic code, but we still get all of the benefits of using concrete types.

This is the general principle for **why** you might want to use generics in your code - now let's get to some examples.

## Generics offer Simple and Automatic Type Constraints

[I've already teased the use of trait bounds with generic types](https://oswalt.dev/2020/07/rust-traits-defining-behavior/) to help you design constraints for types based on their behaviors, such as for function parameters. However, generics themselves offer some basic but useful constraints on their own.

Within a struct definition, for example, we can specify that a given field is a generic type:

```rust
struct Point<T> {
    x: T,
}
```

We've defined a generic type `T`, and then specified that the field `x` is of type `T`. At this point, there is no concrete type specified anywhere. However, once we instantiate this type and assign a specific value to `x`, it will assume the type of whatever concrete value is used:

```rust
// For this instance of Point, the type of `x` is assumed
// to be `i32` (https://doc.rust-lang.org/book/ch03-02-data-types.html#integer-types):
let point = Point{x: 42};
```

Using generic types can also give us some simple constraints that are enforced in our struct automatically. For instance, adding a second field that uses the **same generic parameter T** means that when concrete types are used to instantiate our struct, the **same concrete type** must be used for both fields `x` and `y`:

```rust
struct Point<T> {
    x: T,
    y: T,
}
```

This is apparent when we try to use different types - the below example will not compile:

```rust
let point = Point{
    x: 42,
    y: 24.1,
};
```

The error is on the use of a floating-point number for `y`: `expected integer, found floating-point number`. This is because we used an integer for `x` and because `x` and `y` share a generic parameter, they must be the same concrete type, whatever it is. In plain english, this could be said:

> I don't care what concrete type is used for the `x` or `y` field, but I do care that they're the **same** type.

In function definitions, generics can offer a bit of a useful guarantee. For instance, you may want to pass in multiple parameters, both of which are generic types. You may also want to return a single generic type that matches the same concrete type as the first parameter:

```rust
fn genericfn<T, U>(foo: T, bar: U) -> T {
    foo
}
```

Here, the use of a second generic parameter `U` means that we have two placeholders to use. The `bar` and `foo` parameters don't have to be the same type - the main important thing is that this function returns the same type `T` that is used for the `foo` parameter (which is obviously true in this simple example since we're just returning `foo` right away).

> An important note - in this example, while `foo` and `bar` don't have to be the same type due to our use of different generic parameters, they **still can be**. Just because we're using different generic types doesn't mean the types **have** to be different. They can still both be a `Point` instance, as an example.

As you can see, by using generic parameters on their own, we can accomplish a lot of flexibility and brevity with our code, while still putting up some useful guardrails.

## Generics + Trait Bounds == Superpowers

In the previous examples we really didn't do much with the generic parameters, so we weren't really being challenged:

```rust
fn returnt<T>(foo: T) -> T {
    foo
}
```

When you specify generic parameters, and then attempt to **do** something with those parameters, it can get a bit more interesting - this code will not compile:

```rust
fn printme<T> (x: T) {
    println!("{:?}", x);
}
```

```
error[E0277]: `T` doesn't implement `std::fmt::Debug`
  --> src/main.rs:37:22
   |
37 |     println!("{:?}", x);
   |                      ^ `T` cannot be formatted using `{:?}` because it doesn't implement `std::fmt::Debug`
```

This error is caused by the fact that the Rust compiler knows that the `println` macro requires a type that implements the `std::fmt::Debug` trait, and there is currently no guarantee that the generic type `T` implements this.

As we learned in a previous post, a "trait bound" can help fix this. This places further constraints on the kind of types that can be used for our `printme` function, by only allowing types that implement a given trait:

```rust
fn printme<T: std::fmt::Debug> (x: T) {
    println!("{:?}", x);
}
```

So, where generic types give us the ability to write concise code that works for many different concrete types, traits (when bound to a generic type) allow us to ensure that those types exhibit a certain **behavior**.
What's more is that this is still just another compile-time check. The resulting program is still as statically and concretely typed as ever.

The combination of generics and traits in Rust gives us the same kind of flexibility that we are seeking in a dynamically typed language, but [without any of the runtime tradeoffs](https://doc.rust-lang.org/book/ch10-01-syntax.html#performance-of-code-using-generics). Again, we'll explore this in detail in a future post. 

> While writing my post on [Rust Traits](https://oswalt.dev/2020/07/rust-traits-defining-behavior/), I felt Traits could more or less stand on their own conceptually, but even still, I couldn't avoid the brief mention of generic types in that post. The Rust Book itself seems to acknowledge this intertwined nature of the two concepts by covering them both [in the same section](https://doc.rust-lang.org/book/ch10-00-generics.html). They really are meant to be used together, and it's for this reason why I found it hard to read Rust code until I mastered these two concepts.

The bottom line is, while writing and reading Rust code, we get the flexibility and productivity that would rival a dynamically typed language, but once our program is compiled, we get all of the safety and predictability as if we had just written everything with concrete types ourselves, and all of the unnecessary code duplication that would require.

## Generics in Method Definitions

Defining a method on a type that uses generic types requires us to specify the full type signature in the `impl` statement which includes these types. Since our `Point` struct is actually a `Point<T>`, we must repeat this in the `impl` declaration. What's more is that we actually have to re-define this generic parameter there as well, resulting in:

```rust
// Re-defining the parameter T for this `impl` statement, which makes it available to
// the methods defined below for this generic type.
impl<T> Point<T> {
    // This method returns the same concrete type used for
    // the `x` field of `Point` - we know this because it
    // uses the same generic parameter.
    fn x(&self) -> &T {
        &self.x
    }
}
```

We've already learned that we can declare generic parameters for functions. What's interesting is that we can also do this for methods, even if the type to which those methods belong doesn't use generic types anywhere:

```rust
struct NewStruct {}

// NewStruct doesn't use any generic types,
// so we don't need to specify any here.
impl NewStruct {

    // We can still, however, define our own generic parameters
    // on an individual method as desired
    fn x<T>(&self, foo: T) -> T {
        foo
    }
}
```


# Conclusion

This was a fairly light introduction to the use of generic types in Rust. As stated previously, the docs contain quite a few solid examples as well, so hopefully you're able to start identifying places in your own code where generics can simplify things for you.

In the next post, we'll dive much deeper into how this is implemented under the covers in Rust. Not only are there some interesting details to uncover with how Rust does things here, there are also some interesting options in Rust for accomplishing polymorphism, each of which has its own tradeoffs that are worth considering.
