---
layout: post
title: Cisco UCS ASCII Art
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2013-06-14"
wordpress_id: 3997
slug: cisco-ucs-ascii-art
tags: ['cisco']
---


A while back [I wrote about the problems](https://keepingitclassless.net/2012/10/cisco-ucs-b200-m3-invalid-adaptor-iocard/) with using some of the newer 3rd generation blade hardware from Cisco with older generations of the chassis FEX/IOM. Because of the way that the VIC and the chassis IOM interact, certain combinations yield different amounts of aggregate bandwidth, and certain combinations don't work at all, as was evidenced in that post.

As a reminder, here are the valid combinations (these are still accurate to my knowledge, but may change in a few weeks if any new tech is announced at Cisco Live) of FEX and blade VIC:

[![compatibility matrix](/assets/2012/10/compatibility-matrix.png)](/assets/2012/10/compatibility-matrix.png)

I was reminded by a TAC engineer of a command I'd heard of back when I first learned UCS but had totally forgotten.

Through the (heavily underestimated in my opinion) command line of the UCS Fabric Interconnects, you can log directly into the CLI of the FEX/IOM themselves, and run commands that give an **ascii-based visual representation of the current connectivity between IOM and blades in a chassis**.
    
    F340-31-16-UCS-2-B# connect iom 1
    fex-1# show platform software redwood sts
    Board Status Overview:
     legend:
            ' '= no-connect
            X  = Failed
            -  = Disabled
            :  = Dn
            |  = Up
            ^  = SFP+ present
            v  = Blade Present
    ------------------------------
    
            +---+----+----+----+
            |[$]| [$]| [$]| [$]|
            +---+----+----+----+
              |    |    |    |
            +-+----+----+----+-+
            | 0    1    2    3 |
            | I    I    I    I |
            | N    N    N    N |
            |                  |
            |      ASIC 0      |
            |                  |
            | H H H H H H H H  |
            | I I I I I I I I  |
            | 0 1 2 3 4 5 6 7  |
            +-+-+-+-+-+-+-+-+--+
              - | | | | : | |
             +-+-+-+-+-+-+-+-+
             |-|v|v|v|v|v|v|v|
             +-+-+-+-+-+-+-+-+
    Blade:    8 7 6 5 4 3 2 1


Wild, right? Keep in mind that unless you have a 2104 IOM installed, this command won't work, as "redwood" is the code name for that generation of FEX. If you want to do the same for the 220X series, use the keyword "woodside":
    
    fex-1# show platform software woodside sts
    Board Status Overview:
     legend:
            '  '= no-connect
            X   = Failed
            -   = Disabled
            :   = Dn
            |   = Up
            [$] = SFP present
            [ ] = SFP not present
            [X] = SFP validation failed
    ------------------------------
    
    (FINAL POSITION TBD)     Uplink #:        1  2  3  4  5  6  7  8
                          Link status:        |  |  |  |  :  :  :  :
                                            +-+--+--+--+--+--+--+--+-+
                                  SFP:       [$][$][$][$][ ][ ][ ][ ]
                                            +-+--+--+--+--+--+--+--+-+
                                            | N  N  N  N  N  N  N  N |
                                            | I  I  I  I  I  I  I  I |
                                            | 0  1  2  3  4  5  6  7 |
                                            |                        |
                                            |        NI (0-7)        |
                                            +------------+-----------+
                                                         |
                 +-------------------------+-------------+-------------+---------------------------+
                 |                         |                           |                           |
    +------------+-----------+ +-----------+------------+ +------------+-----------+ +-------------+----------+
    |        HI (0-7)        | |        HI (8-15)       | |       HI (16-23)       | |        HI (24-31)      |
    |                        | |                        | |                        | |                        |
    | H  H  H  H  H  H  H  H | | H  H  H  H  H  H  H  H | | H  H  H  H  H  H  H  H | | H  H  H  H  H  H  H  H |
    | I  I  I  I  I  I  I  I | | I  I  I  I  I  I  I  I | | I  I  I  I  I  I  I  I | | I  I  I  I  I  I  I  I |
    | 0  1  2  3  4  5  6  7 | | 8  9  1  1  1  1  1  1 | | 1  1  1  1  2  2  2  2 | | 2  2  2  2  2  2  3  3 |
    |                        | |       0  1  2  3  4  5 | | 6  7  8  9  0  1  2  3 | | 4  5  6  7  8  9  0  1 |
    +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+
     [ ][ ][ ][ ][ ][ ][ ][ ]   [ ][ ][ ][ ][ ][ ][ ][ ]   [ ][ ][ ][ ][ ][ ][ ][ ]   [ ][ ][ ][ ][ ][ ][ ][ ]
    +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+ +-+--+--+--+--+--+--+--+-+
      -  -  -  -  |  |  |  |     -  -  -  :  |  |  |  |     -  -  -  :  -  -  -  :     |  |  |  |  -  |  -  |
      3  3  3  2  2  2  2  2     2  2  2  2  2  1  1  1     1  1  1  1  1  1  1  9     8  7  6  5  4  3  2  1
      2  1  0  9  8  7  6  5     4  3  2  1  0  9  8  7     6  5  4  3  2  1  0
      ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/  
        blade8      blade7         blade6      blade5         blade4      blade3         blade2      blade1

This is generated in real-time when you run the command. As you can see, you can not only view the status of the physical ports where the FEX is connected to the FI, but also the backplane ports that typically are very misunderstood. The legend is there, you can see the connectivity provided to each blade.

I highly encourage you to visit [this subreddit](http://www.reddit.com/r/Cisco/comments/1c8iz0/cisco_ucs_b200_m3_invalid_adapter_iocard_gotcha/), the TAC engineer on that thread did a great job of explaining exactly the reason for all of this connectivity.
