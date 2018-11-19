---
layout: post
title: Pylint Errors - Final Newline Missing
author: Matt Oswalt
comments: true
categories: ['Code']
date: "2014-05-27"
wordpress_id: 5854
slug: pylint-errors-final-newline-missing
tags: ['pylint']
---


I recently ran into a slew of errors when using [Pylint ](http://www.pylint.org/)- a sort of "quality checker" for your Python code. If you haven't used it yourself, I highly recommend you check it out - it WILL make you a better Python coder.(Thanks to [Matt Stone](https://twitter.com/bigmstone) for introducing me!)

This particular error is common if you forget to append a newline character to the end of your python script, but I was getting one for every single line of code in my program.

    khalis:library Mierdin$ pylint ucs_getwwpns.py 
    No config file found, using default configuration
    C:  1, 0: Final newline missing (missing-final-newline)
    C:  2, 0: Final newline missing (missing-final-newline)
    C:  3, 0: Final newline missing (missing-final-newline)
    C:  4, 0: Final newline missing (missing-final-newline)
    C:  5, 0: Final newline missing (missing-final-newline)
    C:  6, 0: Final newline missing (missing-final-newline)
    C:  7, 0: Final newline missing (missing-final-newline)

You get the idea.

My code clearly has a newline character of some kind at the end, but perhaps it's just not the right one. We need to see what newline character our editor is actually appending to the end of our lines.

For this, we'll use the (*nix) "od" command, which dumps files out to the terminal in various formats. The "-c" flag specifies that we want to see ASCII format, including all backslashed () characters.

[![od](assets/2014/05/od.png)](assets/2014/05/od.png)

As you can see, we're using /r characters instead of what pylint is expecting, which is /n.

This is an easy fix. I tend to go back to Notepad++ for encoding matters like this, so if you navigate to Edit >> EOL Conversion, you'll find three options. Here's what they do.
	
  * Windows - sets to /r/n	
  * UNIX/OSX format - sets to /n
  * Old Mac format - sets to /r

I ensured UNIX/OSX format was chosen, saved my file, and pylint was appeased.

For what it's worth, I was using Atom.io, Github's new editor. I was not able to find a similar conversion method there, or an option to specify the newline character. Feature request?

Happy coding!