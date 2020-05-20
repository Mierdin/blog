---
layout: post
title: "Mutable References To 'self' In Rust's Object Methods"
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://oswalt.dev/assets/2020/05/rust-borrowing.png
date: 2020-05-20T00:00:00-00:00
tags:
  - 'rust'
---

Lately I've been working on graphics programming in Rust, as a continuation of my [first steps with the language](https://oswalt.dev/2020/03/getting-rusty/). As part of this work, I created a type I created called `Vec3f`, to hold cartesian coordinates for a given vector:

```rust
#[derive(Copy, Clone, Debug)]
struct Vec3f {
    x: f32,
    y: f32,
    z: f32
}
```

In the natural course of this work, I needed to add certain methods for this type to allow me to perform calculations like [cross product](http://sites.science.oregonstate.edu/math/home/programs/undergrad/CalculusQuestStudyGuides/vcalc/crossprod/crossprod.html), and [dot/scalar product](https://www.mathsisfun.com/algebra/vectors-dot-product.html). These functions are fairly straightforward and read information from the instance of `Vec3f` (`self`), perform some kind of calculation, and return some kind of result, usually a new `Vec3f` instance, or a simple `f32`.

```rust
impl Vec3f {
    fn new(x: f32, y: f32, z: f32) -> Vec3f {
        Vec3f { x: x, y: y, z: z }
    }

    fn magnitude(self) -> f32 {
        self.dot(self).sqrt()
    }

    fn dot(self, other: Vec3f) -> f32 {
        self.x * other.x + self.y * other.y + self.z * other.z
    }
}
```

In some cases, I want to do more. For instance, a common task in graphics programming is to "[normalize](http://www.fundza.com/vectors/normalize/)" a vector - that is to actively change its properties so that its direction is unchanged, but its magnitude is reduced to 1. Such a vector is also referred to as a [unit vector](https://www.mathsisfun.com/algebra/vector-unit.html).

This is done by multiplying the result of dividing `1.0` over the original magnitude of the vector. In my original attempt, I came up with this:

```rust
impl Vec3f {

   // We intend on mutating this instance of `Vec3f` in-place, so we want
   // to declare the `self` parameter with the `mut` keyword.
   fn normalize(mut self) {
        let mag = self.magnitude();

        // We're reading from a property of "self" to form part of the calculation,
        // and feeding the result back into the appropriate property.
        self.x = self.x * (1.0 / mag);
        self.y = self.y * (1.0 / mag);
        self.z = self.z * (1.0 / mag);
    }
}
```

To demonstrate, we can call this function simply, by first creating an instance of `Vec3f` called `v`, with some made-up coordinates, and then invoking its `normalize()` method, which should change the coordinates in-place to ensure the vector is normalized.

```rust
fn main() {
  let mut v = Vec3f::new(1., 2., 3.);
  v.normalize();
  println!("{:?}", v);
}
```

However, the output shown by the `println` statement seems to indicate something's not quite right:

```rust
Vec3f { x: 1.0, y: 2.0, z: 3.0 }
```

For some reason, the coordinates for our vector have not changed. To begin to troubleshoot this, I added a debug statement to the end of the `normalize()` function, and it seems that the coordinate properties for `self` have indeed been changed at that location. However, our debug statement in the `main()` function doesn't show these changes - it still shows the original values, unaffected.

What gives?!?

## Ownership Strikes Again

It turns out this is yet another instance where Rust's [ownership model](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html) is trying to keep me from doing something stupid.

The first thing that tipped me off to a problem is this warning from the compiler:

```rust
warning: variable does not need to be mutable
  --> examples/blogexample.rs:30:7
   |
30 |   let mut v = Vec3f::new(1., 2., 3.);
   |       ----^
   |       |
   |       help: remove this `mut`
```

It was strange to me that Rust was telling me I didn't need to declare this as mutable. The `normalize()` function absolutely should be mutating `v` - that is its whole purpose. So this keyword **should** be necessary.

You may notice that I'm annotating my `Vec3f` type to automatically [derive](https://doc.rust-lang.org/stable/rust-by-example/trait/derive.html) some implementations, namely:

```rust
#[derive(Copy, Clone, Debug)]
```

If we remove this and try to compile, you'll immediately see why:

```rust
error[E0382]: use of moved value: `self`
  --> examples/blogexample.rs:15:18
   |
14 |     fn magnitude(self) -> f32 {
   |                  ---- move occurs because `self` has type `Vec3f`, which does not implement the `Copy` trait
15 |         self.dot(self).sqrt()
   |         ----     ^^^^ value used here after move
   |         |
   |         value moved here

error[E0382]: use of moved value: `self.z`
  --> examples/blogexample.rs:22:18
   |
18 |     fn normalize(mut self) {
   |                  -------- move occurs because `self` has type `Vec3f`, which does not implement the `Copy` trait
19 |         let mag = self.magnitude();
   |                   ---- value moved here
...
22 |         self.z = self.z * (1.0 / mag);
   |                  ^^^^^^ value used here after move
```

Prior to my attempt to implement the `normalize()` function, I added this annotation so that we could seamlessly use the properties of `Vec3f` for calculations. Thus far, we just needed to return new values, such as `f32` type, based on calculations we can obtain simply by reading from the properties of the vector. We didn't need to change them, just read them.

These are object methods, which use the first parameter `self` (very similar to the way Python does things). One of the rules of [Rust Ownership](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html) is that a value can only have one owner. Since the `Vec3f` type originally had no method for copying or cloning itself (which is the case for any type without an annotation), it moved the ownership for the value into the method.

Because of this behavior, any code after this move is unable to continue to use the value. We're not even able to use the `println` macro to print the result after the `normalize()` function:

```rust
error[E0382]: borrow of moved value: `v`
  --> examples/blogexample.rs:33:20
   |
31 |   let v = Vec3f::new(1., 2., 3.);
   |       - move occurs because `v` has type `Vec3f`, which does not implement the `Copy` trait
32 |   v.normalize();
   |   - value moved here
33 |   println!("{:?}", v);
   |                    ^ value borrowed here after move
```

So, clearly we need the copy functionality, at least the way things are currently implemented. Doing so provides the compiler with an alternative to moving the ownership for these values into a scope where the rest of our code is left hanging out to dry.

# Mutable References to the Rescue!

Okay so we've figured out that to get our code to compile, we need to annotate our structs so that we automatically get Copy/Clone capabilities for them. However, this doesn't solve our original problem, which is that our object method didn't appear to be actually mutating our `Vec3f` instance like we wanted.

Well, since we now know that within the context of this method, `self` is actually a **copy** of this value, it suddenly becomes obvious that all we're doing is mutating this copied value, not the original instance, which is still owned by the variable `v` in our `main()` function.

There is another way, that doesn't require a move, or a copy, and that is to declare `self` in this function as a [mutable reference](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html#mutable-references). We can do this by adding an ampersand before the `mut` keyword:

```rust
fn normalize(&mut self) {
    let mag = self.magnitude();
    self.x = self.x * (1.0 / mag);
    self.y = self.y * (1.0 / mag);
    self.z = self.z * (1.0 / mag);
}
```

Prior to this change, since `self` was a copy of the value, all we were doing was declaring that we wanted to be able to mutate that copy. By adding the ampersand, we're allowing the `normalize` function to actually borrow ownership of the original value; together with the `mut` keyword, we're now able to make the changes successfully. Re-running this example shows a normalized vector:

```rust
Vec3f { x: 0.26726124, y: 0.5345225, z: 0.8017837 }
```

> Note that rust only allows one mutable reference to a variable at a time, but fortunately that's all we need our function takes the reference, makes a quick change, and returns. The calling code blocks until this is done, at which point the scope the mutable reference was created in is gone.

# Someday I'll Learn

I'm still new to Rust, and I have to say that I have read the [chapter on ownership and borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html) a few times now, and I don't think I really "got it" until this problem bit me. Nothing like a few battle scars to really hammer home the hard lessons! :)

Hopefully it helped you.
