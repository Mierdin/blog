---
layout: post
title: 'Rust: Constants, Variables, and Mutability - Oh My!'
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://oswalt.dev/assets/2020/03/rusty.jpg
date: 2020-03-05T00:00:00-00:00
tags:
  - 'rust'
---

In the [last post](https://oswalt.dev/2020/03/getting-rusty/) I wrote about my journey from Python to Go as my primary language, and how I am now exploring Rust.

This will be the first in a series of posts on Rust, mostly written from this perspective. I realize not everyone is going to Rust from Go, but that's my perspective, and it will be impossible to keep this perspective from showing through and making comparisons between Rust and Go or Python. I believe we learn best by building on what we know, so I'll be making a lot of these comparisons for my own edification. Deal with it. :)

The way I'll write this series is by going through the [Rust book](https://doc.rust-lang.org/book/) and basically providing commentary on it. I'll make observations about things I see and lessons I learn, as well as some comparisons to concepts I'm already familiar with. For this, a good place to start is [Chapter 3 - Common Programming Concepts](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html) where I can make some comparisons to what I know.

> I do recommend going through [Chapter 1](https://doc.rust-lang.org/book/ch01-03-hello-cargo.html) on a **real** hello, world example, and the subsequent [Chapter 2](https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html) which is a slightly more advanced hello world example that doesn't dive super deep, but is a nice whirlwind tour of the basic, basic concepts in Rust. I think they did a good job of showing you a practical example that piques interest before diving into the deeper reference-style content of chapters 3+.

## Variables and Mutability

As I mentioned in my previous post, what I'm liking a lot about Rust is just how much it forces you to let the compiler do all the work. Reducing runtime uncertainty and forcing the programmer to be intentional with what they're allocating lends itself to a more stable application. This is made very evident even in [fundamental concepts like defining variables](https://doc.rust-lang.org/book/ch03-01-variables-and-mutability.html).

In Go, and many other languages, you typically have the ability to define variables, or constants. This is offered typically because the underlying implementation for constants is simpler and less expensive, so if you know a certain value isn't going to change once you set it, choosing to declare it as a constant is the better option. However, you typically have to explicitly declare it this way. For instance, in Go, you have to use either the keyword `var`, or `const` accordingly:

```go
// (go)

// This is a constant. If we try to re-assign to this,
// we'll get a compiler error.
const strConst = "Hello!"

// This is a variable. We can re-assign to this to our
// heart's delight.
var strVar = "Hello!"
```

Many languages work this way. However, Rust **defaults to immutability**, meaning unless you state otherwise, it assumes that what you're creating should be treated like a constant. To facilitate this, the `mut` keyword can be used to indicate a variable should be mutable:

```rust
// (rust)

// This is an integer without the "mut" keyword, and therefore
// defaults to immutable. We will get a compiler error if we try
// to change this.
let intConst = 5;

// The "mut" keyword means we're "opting in" to mutability here,
// so "intVar" will act like a traditional variable. We can change it.
let mut intVar = 5;
```

I do like that this forces me to think carefully every time I allocate something, about whether or not what I'm working with should be mutable, or if I could get away with immutability. It seems like most things in Rust are this way; a little bit of extra thinking before compilation means that much more safety at runtime. Defaulting to an immutable value may seem like an obstacle, but if it eliminates an entire class of bugs, I'm all for it.

> It **does** bug me that this means the oxymoronic term "immutable variable" is now a thing, but I expect I'll get over it.

## Constants are Dead? Wait, no.

I started writing this section before I had scrolled down and saw ["Differences between Constants and Variables"](https://doc.rust-lang.org/book/ch03-01-variables-and-mutability.html#differences-between-variables-and-constants). It turns out that even though we can create "immutable variables", Rust still has the concept of a "constant", and that section enumerates a few key differences between the two.

To be honest, the first three made me go "meh" at first. In short:

- Constants are non-optionally immutable.
- The syntax for constants is different, as one might expect.
- Constants can be declared anywhere.

When I say these made me go "meh", I mean that while these are expected, I couldn't see enough of a justification for keeping constants around while we have the ability to create immutable variables. But then I read the fourth and final difference between the two:

> "The last difference is that constants may be set only to a constant expression, not the result of a function call or any other value that could only be computed at runtime."

This tells me that while we can optimize our code by defaulting variables to "immutable", Rust still needs to do a little bit of extra work to make that structure available at runtime to be filled by a value that may come from something like a function call. So while we remove a lot of the variability that comes from making a variable mutable, there's still some dynamic runtime behavior in there.

The fact that a constant **must** be set via a constant expression, and **cannot** be set from a function call tells me that from an implementation perspective, there's some kind of additional efficiency from doing it this way. 

While this is confusing at first, I do like that this means we now have three layers of mutability:

- Constants (most inflexible, most efficient)
- Immutable Variables (efficient, but still useful in a variety of use cases)
- Mutable Variables (most flexible)

Again, this is clearly more involved than other languages, but the result is more control over your application's footprint.


# Shadowing

Shadowing kind of blew my mind a little bit when I read that section, but it's actually quite simple. And it is very on-theme for Rust, in that it's designed to give us additional flexibility without compromising on compile-time safety too much.

In general, shadowing can be used as a way of re-declaring a variable. In particular, this is useful when you want to keep a variable as immutable, but you would still like to be able to change it.

The example they give in the book is that they set `x` to an integer value of 5, and then perform math on it, changing it along the way, by redeclaring each time.

```rust
fn main() {

    // First declaration of x
    let x = 5;

    // At this point, x is 5, so this is like saying
    // x = 5 + 1, which result in 6
    let x = x + 1;

    // At this point, x is 6, so this is like saying
    // x = 6 * 2, which results in 12.
    let x = x * 2;

    // "The value of x is: 12"
    println!("The value of x is: {}", x);
}
```

This is another thing you couldn't do with constants, by the way. Try to compile this program:

```rust
const X: i32 = 100;

fn main() {
    let X = 5; // <---- compiler error here
    println!("The value of X is: {}", X);
}
```

and you'll get:

```bash
error[E0005]: refutable pattern in local binding: `std::i32::MIN..=99i32` and `101i32..=std::i32::MAX` not covered
 --> src/main.rs:4:9
  |
4 |     let X = 5;
  |         ^ interpreted as a constant pattern, not new variable
```

# Conclusion

I'm making a lot of inferences based on what I can see about the syntax, about how certain declarations can be more or less efficient. Some day I might dive deeper and figure out how Rust actually implements these things to achieve these goals, but for now I'll be content to trust the language's idioms.

My takeaways, for now, are:

- The three mutability options I stated above gives a bit more control over the footprint of our data. Defaulting to immutability is a little annoying at first, but to be honest, so was strong typing when I moved from Python to Go in the first place. I grew to appreciate its benefits, and I expect I'll feel the same way here.

- The `let` keyword is a constant reminder that you're declaring (or in the case of shadowing, re-declaring) something. It's a little additional syntax that reminds you of what's going on. If what you're trying to do is shadow a variable, it does have a way of reminding you that re-declaring the variable is necessary, which gives you an opportunity to consider if you're doing the right thing.
