---
layout: post
title: Host Interfaces on UCS FEX 2204 vs FEX 2208
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2013-06-20"
wordpress_id: 4086
slug: host-interfaces-on-ucs-fex-2204-vs-fex-2208
tags: ['bandwidth']
---


I mentioned in a [previous post](https://oswalt.dev/2013/06/cisco-ucs-ascii-art/) regarding the connectivity options to each blade if you're using the appropriate hardware.

If you're using a 2208 FEX, you have 8 upstream ports, each at 10GbE. This means the FEX can support up to 80 Gbps total. You can provide potentially 4:1 oversubscription (math later) to each blade by connecting a 2208 FEX into a blade chassis with blades that can also support 80Gbps each.
    
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
      ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/ 
        blade8      blade7         blade6      blade5         blade4      blade3         blade2      blade1


The text shown above indicates that not only do I have 8 physical uplinks, but also each FEX offers up to 4 Host Interfaces (HIFs) per blade. This means that up to 40Gbps can be realized per blade, per fabric. This is where the 4:1 oversubscription ratio comes from.

Contrast that to a 2204 FEX, which has only 4 physical uplinks for a total of 40Gbps;

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
                          Link status:        |  |  |  |
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
            -  -        -  -           -  -        -  -           -  -        -  |           -  |        -  |
            1  1        1  1           1  1        1  9           8  7        6  5           4  3        2  1
            6  5        4  3           2  1        0
      ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/     ____/__/  ____/__/ 
        blade8      blade7         blade6      blade5         blade4      blade3         blade2      blade1

However, according to the output, the number of HIFs is the same, so I could potentially use a VIC 1280 (or at least a port expander) in the mezz slot to get the full 4 ports lit up per blade. This means that there is no difference between the 2204 and 2208 in terms of  downward-facing blade connectivity. In theory, if you have the right combination of cards inside the blade, you should be able to light up 1, 2, or 4 connections to each FEX, for a grand maximum of 80Gbps per blade (40 per FEX).

However, if you're using the 2204 FEX, you're oversubscribing by twice the amount: If I do indeed light up four connections per blade, that means that I've promised each blade 40Gbps worth of bandwidth per FEX, and 40Gbps is all I have total, so that's an oversubscription ratio of 8:1. If I were to use the 2208 FEX, and connect all 8 upstream ports, then I'm only oversubscribed 4:1.

## Conclusion

All of that said - the chart provided by Cisco for the B200 M3 (page 20 of [this](http://www.cisco.com/en/US/prod/collateral/ps10265/ps10280/B200M3_SpecSheet.pdf)) does not show any 80Gbps connectivity options for any blade without using the 2208 XP. Now - if 80 Gbps to the blade was **really** important to me then yeah  - I wouldn't want to oversubscribe 8:1 either. But from my perspective it seems possible.

Since the blade hardware is the same between both instances, and the only difference is the FEX model, it looks like the two extra HIFs are simply disabled - UCS knows that the blade hardware supports 4 paths to each FEX but disables them to avoid such a drastic oversubscription.

I'd love someone from Cisco's UCS team to step in and validate all of this for me in the comments section, but this is what logical deduction seems to be telling me.

> **EDIT**: I've confirmed that the 2204 has 16 Host Ports, whereas the 2208 has 32. So the placement of host interfaces is cut in half in the presence of a 2204. Refer to the whitepaper on the current generation of UCS FEX: [http://www.cisco.com/en/US/prod/collateral/ps10265/ps10276/data_sheet_c78-675243.html](http://www.cisco.com/en/US/prod/collateral/ps10265/ps10276/data_sheet_c78-675243.html)

So...the cool ASCII art mentioned earlier is not a true reflection of the actual number of host ports available. The output for the 2204 seems to indicate up to 4 per blade (max) but in reality, it is two.
