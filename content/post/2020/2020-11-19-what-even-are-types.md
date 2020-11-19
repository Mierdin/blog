---
layout: post
title: "What Are Data Types Anyways?"
author: Matt Oswalt
comments: true
categories: ['Programming']
featured_image: https://oswalt.dev/assets/2020/11/keys.jpg
date: 2020-11-19T00:00:00-00:00
tags:
  - rust
  - types
---

There are actually quite a few resources out there for a novice programmer to learn about data types like strings, integers, floats, and more. The [wikipedia page](https://en.wikipedia.org/wiki/Data_type), as an example, covers a broad spectrum of potential meanings. Just about any book or tutorial focused on a particular programming language will start off by listing the types supported by that language. This makes sense, since they are the fundamental building block of being able to do pretty much **anything** in that language. What's more is that once you've learned the types in one language, the vast majority will also be supported in any other language, with worst case being a slightly different name or syntax.

As a result, data types (at least the common/simple ones) are a concept that the vast majority of us - even programmers with only a modicum of experience - are able to grasp to the point of taking it for granted. Programmers who learned with modern technology may be satisfied that strings are for "a series of characters", and integers are for "numbers", and not have to wonder what that **actually means**. And to be honest, I'm not sure there's anything wrong with leaving it at that in some cases - a lot of perfectly functional software has been created by simply using the tools of a language without asking questions.

However, as I [quest to dive deeper](https://oswalt.dev/2020/01/returning-to-first-principles/), I try to ask these questions whenever I can, and in this case, I think it's important to call out a fundamental truth that may not be as obvious to anyone who didn't go through a traditional computer science education.

## The Truth about Types

So before I further bury the lede, I'll come right out with it, as succinctly as I wish it was stated to me early on:

> <p style="font-size:20px;"><strong>Types are a memory offset abstraction.</strong></p>

That's it. The purpose of having types like `integers`, `strings`, and `floats`, as well as providing primitives for defining your **own** types (like structs) is so the compiler knows how much memory to allocate for a given chunk of data. It is an abstraction that is **only useful at compile time**, and exists for the purpose of making it easier for the programmer to reason about these allocations without realizing it.

In the coming sections, we'll explore some examples that illustrate this truth. Before we get there, I have two disclaimers:

- I'll be focusing on types as they pertain to procedural programming and related concepts. Object-oriented languages add further abstraction on top of what we'll discuss here. Indeed there are other similar rabbit holes I could dive into, but we'll keep away from all these in the name of simplicity.

- I'll be using Rust to illustrate some examples, but keep in mind that each language has not only its own syntax for built-in and user-defined types, but also may vary in the way those types are manifested in machine code. Also I'll be using the default debug options for `cargo` so your code may compile differently based on the options you select. The specifics don't matter as much as gaining the skills to "peek behind the curtain".

## Simple Example (Built-In Integer Types)

Above, I referred to types as a "memory offset abstraction". For now let's focus on the term "memory offset" for those that may not be familiar. In my [previous post](https://oswalt.dev/2020/11/anatomy-of-a-binary-executable/), when examining the disassembled instructions of a simple program, we could see that certain instructions were provided at a given **byte offset**, which indicated the number of bytes from 0 that instruction was located at within the file.

Similarly, for those readers with a networking background, the protocols we know and love like the [Internet Protocol (IP)](https://tools.ietf.org/html/rfc791#section-3.1) have standardized header formats for the same reason. In the Internet Protocol (IP) header, we don't need some kind of "special signal" so that a router knows when it has read the full source address field - we specified in the standard that this field is 32 bits long. So, when we get that 32nd bit, we know the field is over and we're starting to receive the next one.

In general summary, the reason we like to work with well-known memory offsets is that it makes things easy to write software for. The problem is that in modern applications, it can get **very** tedious to only work with these memory offsets - so, most languages offer "data types" as an abstraction so that the programmer doesn't constantly have to think about how many bytes a given type needs to have allocated - the compiler can do that work for us.

For instance, the following Rust example creates a variable `x`, and assigns it the value `5`. While Rust would automatically assume this is a 32-bit integer, we're going to be explicit about it for the sake of the illustration, so we'll add the type coercion to `i32`:

```rust
fn main() {
    let x: i32 = 5;
}
```

If you recall from my [previous post](https://oswalt.dev/2020/11/anatomy-of-a-binary-executable/), we can explore the compiled machine code using the `objdump` tool. My usage here is almost the same, but I'm adding the `--disassemble=rbin::main` flag so I can go directly to the relevant code for this example. I'm also using the `-S` flag which interleaves the rust source code within the machine code so we can more clearly see how the Rust and machine code relate to each other:

```bash
~$ objdump --disassemble=rbin::main -S -C target/debug/rbin -EL -M intel --insn-width=8
target/debug/rbin:     file format elf64-x86-64

...

0000000000005310 <rbin::main>:
fn main() {
    5310:	48 83 ec 04             	sub    rsp,0x4
    let x: i32 = 5;
    5314:	c7 04 24 05 00 00 00    	mov    DWORD PTR [rsp],0x5
}
    531b:	48 83 c4 04             	add    rsp,0x4
    531f:	c3                      	ret    

Disassembly of section .fini:
```

> Pay careful attention to the output, there is both Rust and machine code there, due to the `-S` flag. Anything that follows the four-column format (offset, bytes, instruction, parameters) is machine code, the rest is Rust (ignoring any output from `objdump` itself). Only the machine code makes it into the resulting compiled program, the rest is provided by `objdump` to help us make sense of things.

The first instruction allocates four bytes of stack space for the `main` function:

```bash
sub    rsp,0x4
```

Why is the compiler allocating 4 bytes? Well it turns out that this is exactly how much is needed for a 32 bit integer (4 bytes x 8 = 32), and moving a value into this memory space is the only operation taking place in this function, so that is all the space we need.

Next, we can move the hexidecimal equivalent of `5` into this memory space:

```bash
mov    DWORD PTR [rsp],0x5
```

[`rsp` is the stack pointer](https://software.intel.com/content/www/us/en/develop/articles/introduction-to-x64-assembly.html), and at this point in the program is pointing to the memory location where our allocation begins - so we can specify this as the location in memory where our value can be written.

This example was a little too simple, so let's add a few more assignments (`y` and `z`) to highlight the significance of memory offsets:

```bash
0000000000005310 <rbin::main>:
fn main() {
    5310:	48 83 ec 0c             	sub    rsp,0xc
    let x: i32 = 5;
    5314:	c7 04 24 05 00 00 00    	mov    DWORD PTR [rsp],0x5
    let y: i32 = 255;
    531b:	c7 44 24 04 ff 00 00 00 	mov    DWORD PTR [rsp+0x4],0xff
    let z: i32 = 0;
    5323:	c7 44 24 08 00 00 00 00 	mov    DWORD PTR [rsp+0x8],0x0

}
    532b:	48 83 c4 0c             	add    rsp,0xc
    532f:	c3                      	ret    
```

This example makes things a bit clearer. Our stack allocation is now much larger than 4 bytes; `0xc`, when converted from hexidecimal, is `12`. Again, this allocation is made as the result of a calculation by the compiler. It knows we are assigning to 3 variables, and each is a 32-bit integer. Since each requires 4 bytes, we'll need a total of 12 bytes to perform these operations:

```bash
5310:	48 83 ec 0c             	sub    rsp,0xc
```

Our assignment to `x` is the same as before, but notice that the machine code for the assignment to `y` has some extra syntax:

```bash
531b:	c7 44 24 04 ff 00 00 00 	mov    DWORD PTR [rsp+0x4],0xff
```

The value `0xff` is hex for 255, so that's the actual data we're storing, but the memory location is provided as a **memory offset** from the stack pointer `rsp` - namely four bytes (`rsp+0x4`). This actually has a lot less to do with `y`, and more to do with `x`. The type we're using for `x` requires four bytes of memory, so the starting location in memory that should be used for `y` is the address that is **four bytes offset** from the address used to store that value, which in this case was the location indicated by `rsp`.

Confused? Try using 16-bit integers instead:

```bash
0000000000005310 <rbin::main>:
fn main() {
    5310:	48 83 ec 06             	sub    rsp,0x6
    let x: i16 = 5;
    5314:	66 c7 04 24 05 00       	mov    WORD PTR [rsp],0x5
    let y: i16 = 255;
    531a:	66 c7 44 24 02 ff 00    	mov    WORD PTR [rsp+0x2],0xff
    let z: i16 = 0;
    5321:	66 c7 44 24 04 00 00    	mov    WORD PTR [rsp+0x4],0x0
}
    5328:	48 83 c4 06             	add    rsp,0x6
    532c:	c3                      	ret    
```

Our stack allocation is now much smaller, and the byte offsets for each is also cut in half. `y` only needs to be stored 2 bytes ahead of `x`, since `x` only occupies that much space. Incidentally, `y` is the same size, so `z` can go 2 bytes ahead of that (`rsp` plus four bytes).

This was a simple example, but the details here are very important if you want to understand how much of modern software **actually works**. We'll continue to build on this, but I'd like to call attention to two specific takeaways before I proceed:

- At no point did we as Rust programmers have to specify the memory offset ourselves. We specified the type `i32`, which is an alias for the 32-bit memory offset that this type requires, and the compiler took care of allocating memory for us, and moving our desired values into the correct memory locations, calculating the necessary offset based on the size needed for each type. Other languages may use even simpler names like `int`, but usually these have a default memory offset and it's valuable for you to know what that is.

- Note also that there's no mention of `i32` in the machine code (as a point of clarification, we did see this in the output of `objdump` but remember that was just some nice comparison output provided by the tool so we knew where the machine code came from pre-compilation - none of the rust code was actually present in the resulting binary). **Types** are a tool for the compiler to make life easier for the programmer; the programmer uses these types, and the compiler interprets their usage to know how much memory to allocate, and where to place values. Once it has done that, it has no need for this abstraction.

# Custom Types, Arrays, and Vecs

It turns out that `structs` are really not that different. They are a collection of memory offsets. Let's create a struct `Point` with two integer fields, and instantiate it:

```rust
fn main() {
    let p = Point { x: 5, y: 2 };
}

struct Point {
    x: i32,
    y: i32,
}
```

When it comes to the underlying machine code, each field is four bytes, and so the first field is stored at the location of `rsp`, and the second field four bytes after that:

```bash
0000000000005310 <rbin::main>:
fn main() {
    5310:	50                      	push   rax
    let p = Point { x: 5, y: 2 };
    5311:	c7 04 24 05 00 00 00    	mov    DWORD PTR [rsp],0x5
    5318:	c7 44 24 04 02 00 00 00 	mov    DWORD PTR [rsp+0x4],0x2
}
    5320:	58                      	pop    rax
    5321:	c3                      	ret    
```


> You might notice in the output above that the first instruction is `push rax` rather than the stack allocation instruction we've been seeing (e.g. `sub    rsp,<bytes>`). In my initial research, it appears that this is done for [stack alignment purposes](https://stackoverflow.com/a/37774474), but there's no `call` instruction following this, so I don't think that's what's happening here.
>
> Instead, I believe this is just a shortcut taken by the Rust compiler to [allocate 8 bytes on the stack](https://stackoverflow.com/a/40310205) more efficiently. This is the size of our struct, so this makes sense - adding or removing fields results in a `sub` call. When you can see this, for the sake of the example, you can view this as equivalent to `sub    rsp,0x8`. You'll also note the call `pop rax` follows at the end, which returns this space back to the stack.

Arrays follow the same formula as well:

```bash
0000000000005310 <rbin::main>:
fn main() {
    5310:       50                              push   rax
    let ints = [5, 2];
    5311:       c7 04 24 05 00 00 00            mov    DWORD PTR [rsp],0x5
    5318:       c7 44 24 04 02 00 00 00         mov    DWORD PTR [rsp+0x4],0x2
}
    5320:       58                              pop    rax
    5321:       c3                              ret
```

A fun thing to try here would be to use a [Vec](https://doc.rust-lang.org/std/vec/index.html) instead of an array. You'll notice this gets a whole lot more complex:

```bash
0000000000006330 <rbin::main>:
fn main() {
    6330:       48 83 ec 18                     sub    rsp,0x18
    let ints = vec![5, 2];
    6334:       bf 08 00 00 00                  mov    edi,0x8
    6339:       be 04 00 00 00                  mov    esi,0x4
    633e:       e8 dd f1 ff ff                  call   5520 <alloc::alloc::exchange_malloc>
    6343:       48 89 c1                        mov    rcx,rax
    6346:       c7 00 05 00 00 00               mov    DWORD PTR [rax],0x5
    634c:       c7 40 04 02 00 00 00            mov    DWORD PTR [rax+0x4],0x2
    6353:       48 89 e7                        mov    rdi,rsp
    6356:       48 89 ce                        mov    rsi,rcx
    6359:       ba 02 00 00 00                  mov    edx,0x2
    635e:       e8 dd fe ff ff                  call   6240 <alloc::slice::<impl [T]>::into_vec>
}
    6363:       48 89 e7                        mov    rdi,rsp
    6366:       e8 15 fc ff ff                  call   5f80 <core::ptr::drop_in_place>
    636b:       48 83 c4 18                     add    rsp,0x18
    636f:       c3                              ret   
```

A simple array is stack-allocated, whereas a [Vec is heap-allocated](https://doc.rust-lang.org/std/vec/index.html), which requires an extra call, and thus the added complexity. This is expected, but the thing to note is that despite the method of allocation, the memory layout for the types being allocated **for** is identical.

# Conclusion

A few parting thoughts:

- This was a simple, illustrative example. The specifics of what you read above aren't as important as getting in the habit of poking around the machine code to see what that high level code you're writing **actually does**. It's a good habit I'm trying to get into myself, and would encourage you to do the same.

- Most of what we looked at were simple stack-allocated values. When allocating heap memory for data, the process by which that memory is acquired might be different, but you still need to know the shape of your data no matter where it's being stored.

- The [`memoffset`](https://docs.rs/memoffset/0.6.1/memoffset/index.html) crate is useful for getting the offset of certain types via compile-time macros. I've run into a few use cases (specifically in graphics programming) where the size of a given type needs to be known prior to making use of it in certain APIs, and this is helpful for that.