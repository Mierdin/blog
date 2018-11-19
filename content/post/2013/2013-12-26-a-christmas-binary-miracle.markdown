---
layout: post
title: A Christmas Binary Miracle
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2013-12-26"
wordpress_id: 5237
slug: a-christmas-binary-miracle
tags: ['binary']
---


My brother got a little puzzle in his stocking this Christmas. It was a little cardboard booklet, and on each page was written a block of numbers, like so:

    
    BLOCK ONE
    1    3    5    7    9    11   13   15
    17   19   21   23   25   27   29   31
    33   35   37   39   41   43   45   47
    49   51   53   55   57   59   61   63
    
    BLOCK TWO
    2    3    6    7    10   11   14   15
    18   19   22   23   26   27   30   31
    34   35   38   39   42   43   46   47
    50   51   54   55   58   59   62   63
    
    BLOCK THREE
    4    5    6    7    12   13   14   15
    20   21   22   23   28   29   30   31
    36   37   38   39   44   45   46   47
    52   53   54   55   60   61   62   63
    
    BLOCK FOUR
    8    9    10   11   12   13   14   15
    24   25   26   27   28   29   30   31
    40   41   42   43   44   45   46   47
    56   57   58   59   60   61   62   63
    
    BLOCK FIVE
    16   17   18   19   20   21   22   23
    24   25   26   27   28   29   30   31
    48   49   50   51   52   53   54   55
    56   57   58   59   60   61   62   63
    
    BLOCK SIX
    32   33   34   35   36   37   38   39
    40   41   42   43   44   45   46   47
    48   49   50   51   52   53   54   55
    56   57   58   59   60   61   62   63

You're to ask someone to pick any number they see in any block, and don't tell you what it is. They are, however, required to find every instance of that number in the entire booklet, and tell you which blocks of numbers that specific number shows up in. Of those blocks that they've identified, you as the "puzzler" are supposed to add the first number (top left corner) in each of those blocks, and the resulting number will be the number they selected.

Try it out. Let's say our number is 54. The number 54 is present on blocks 2, 3, 5, and 6. The first numbers in those blocks are 2, 4, 16, and 32 respectively. The sum of those four numbers is 54.

Pretty cool, eh?

## Spoilers Below!!

I don't post a lot of purely math-related content, but I did so here because there's a parallel between the math behind this puzzle and network engineering.

If you take a look at the first number in each block, you'll notice they're all significant decimal numbers when translating to binary. These are all the highest values that each binary digit, in order, can represent.

For instance, the first bit in a binary string can only describe, at most, the number 1. A second bit is twice that, because a binary string of "10" is equal to 2, and so on up to the 6th block, which is equivalent to a 6-bit string (100000 in binary equals 32). So, if you assign bit values to each block of numbers, it correlates to a binary digit.

Let's pick on our example again. We had the number 54, and noticed that it was present in blocks 2, 3, 5, and 6. Well, if we take our six blocks, and represent each with a binary digit - setting that digit to 1 if the number is present, and 0 if it is not, we get "011011". That is the binary equivalent to the number 54.

It follows, then, that each block contains literally all numbers that have that respective bit value set to 1 in a six-bit binary number. Take block 3 for example. The third bit (that holds the "4" value in decimal) is set to 1 for every single number in that block.

What you're doing by solving this puzzle is actually what network engineers do when they do binary conversions, such as when subnetting. It binary, or base2 math at it's core, and functions exactly the same way.

Now that's cool.

## Glutton for Punishment

Because of the parallels with network engineering, you may also think of a 6-bit puzzle as a little.......incomplete. We like to deal with binary values in 8-bit chunks. So I set out to see the impact of adding two bits to this puzzle. After all, how hard could it be, just adding two bits? Keep in mind that for every bit you add, you're doubling the scope of the puzzle. So, since we added TWO bits, we doubled, and then doubled again. This impacts not only the number of potential values, but also the number of rows, and the number of blocks.

So this is what happened:
    
    BLOCK ONE
    1    3    5    7    9    11   13   15
    17   19   21   23   25   27   29   31
    33   35   37   39   41   43   45   47
    49   51   53   55   57   59   61   63
    65   67   69   71   73   75   77   79
    81   83   85   87   89   91   93   95
    97   99   101  103  105  107  109  111
    113  115  117  119  121  123  125  127
    129  131  133  135  137  139  141  143
    145  147  149  151  153  155  157  159
    161  163  165  167  169  171  173  175
    177  179  181  183  185  187  189  191
    193  195  197  199  201  203  205  207
    209  211  213  215  217  219  221  223
    225  227  229  231  233  235  237  239
    241  243  245  247  249  251  253  255
    
    BLOCK TWO
    2    3    6    7    10   11   14   15
    18   19   22   23   26   27   30   31
    34   35   38   39   42   43   46   47
    50   51   54   55   58   59   62   63
    66   67   70   71   74   75   78   79
    82   83   86   87   90   91   94   95
    98   99   102  103  106  107  110  111
    114  115  118  119  122  123  126  127
    130  131  134  135  138  139  142  143
    146  147  150  151  154  155  158  159
    162  163  166  167  170  171  174  175
    178  179  182  183  186  187  190  191
    194  195  198  199  202  203  206  207
    210  211  214  215  218  219  223  224
    227  228  231  232  235  236  239  240
    243  244  247  248  251  252  254  255
    
    BLOCK THREE
    4    5    6    7    12   13   14   15
    20   21   22   23   28   29   30   31
    36   37   38   39   44   45   46   47
    52   53   54   55   60   61   62   63
    68   69   70   71   76   77   78   79
    84   85   86   87   92   93   94   95
    100  101  102  103  108  109  110  111
    116  117  118  119  124  125  126  127
    132  133  134  135  140  141  142  143
    148  149  150  151  156  157  158  159
    164  165  166  167  172  173  174  175
    180  181  182  183  188  189  190  191
    196  197  198  199  204  205  206  207
    212  213  214  215  220  221  222  223
    228  229  230  231  236  237  238  239
    244  245  246  247  252  253  254  255
    
    BLOCK FOUR
    8    9    10   11   12   13   14   15
    24   25   26   27   28   29   30   31
    40   41   42   43   44   45   46   47
    56   57   58   59   60   61   62   63
    72   73   74   75   76   77   78   79
    88   89   90   91   92   93   94   95
    104  105  106  107  108  109  110  111
    120  121  122  123  124  125  126  127
    136  137  138  139  140  141  142  143
    152  153  154  155  156  157  158  159
    168  169  170  171  172  173  174  175
    184  185  186  187  188  189  190  191
    200  201  202  203  204  205  206  207
    216  217  218  219  220  221  222  223
    232  233  234  235  236  237  238  239
    248  249  250  251  252  253  254  255
    
    BLOCK FIVE
    16   17   18   19   20   21   22   23
    24   25   26   27   28   29   30   31
    48   49   50   51   52   53   54   55
    56   57   58   59   60   61   62   63
    80   81   82   83   84   85   86   87
    88   89   90   91   92   93   94   95
    112  113  114  115  116  117  118  119
    120  121  122  123  124  125  126  127
    144  145  146  147  148  149  150  151
    152  153  154  155  156  157  158  159
    176  177  178  179  180  181  182  183
    184  185  186  187  188  189  190  191
    208  209  210  211  212  213  214  215
    216  217  218  219  220  221  222  223
    240  241  242  243  244  245  246  247
    248  249  250  251  252  253  254  255
    
    BLOCK SIX
    32   33   34   35   36   37   38   39
    40   41   42   43   44   45   46   47
    48   49   50   51   52   53   54   55
    56   57   58   59   60   61   62   63
    96   97   98   99   100  101  102  103
    104  105  106  107  108  109  110  111
    112  113  114  115  116  117  118  119
    120  121  122  123  124  125  126  127
    160  161  162  163  164  165  166  167
    168  169  170  171  172  173  174  175
    176  177  178  179  180  181  182  183
    184  185  186  187  188  189  190  191
    224  225  226  227  228  229  230  231
    232  233  234  235  236  237  238  239
    240  241  242  243  244  245  246  247
    248  249  250  251  252  253  254  255
    
    BLOCK SEVEN
    64   65   66   67   68   69   70   71
    72   73   74   75   76   77   78   79
    80   81   82   83   84   85   86   87
    88   89   90   91   92   93   94   95
    96   97   98   99   100  101  102  103
    104  105  106  107  108  109  110  111
    112  113  114  115  116  117  118  119
    120  121  122  123  124  125  126  127
    192  193  194  195  196  197  198  199
    200  201  202  203  204  205  206  207
    208  209  210  211  212  213  214  215
    216  217  218  219  220  221  222  223
    224  225  226  227  228  229  230  231
    232  233  234  235  236  237  238  239
    240  241  242  243  244  245  246  247
    248  249  250  251  252  253  254  255
    
    BLOCK EIGHT
    128  129  130  131  132  133  134  135
    136  137  138  139  140  141  142  143
    144  145  146  147  148  149  150  151
    152  153  154  155  156  157  158  159
    160  161  162  163  164  165  166  167
    168  169  170  171  172  173  174  175
    176  177  178  179  180  181  182  183
    184  185  186  187  188  189  190  191
    192  193  194  195  196  197  198  199
    200  201  202  203  204  205  206  207
    208  209  210  211  212  213  214  215
    216  217  218  219  220  221  222  223
    224  225  226  227  228  229  230  231
    232  233  234  235  236  237  238  239
    240  241  242  243  244  245  246  247
    248  249  250  251  252  253  254  255

Notice that the last number is 255 - this is because if all bits in an 8-bit binary number are set to 1, then the resulting decimal number is 255. This is why it's the last number in every single block.

Hope everyone had a great Christmas and that it's not too late to throw this puzzle in front of some relatives and blow them away with math!
