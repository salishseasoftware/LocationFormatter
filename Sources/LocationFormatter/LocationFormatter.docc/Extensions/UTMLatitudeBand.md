# ``LocationFormatter/UTMLatitudeBand``

## Overview

Latitude bands are not a part of the [Universal Transverse Mercator (UTM) coordinate system](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system), but rather a part of the Military Grid Reference System (MGRS). They
are however often used.

Each longitude zone is segmented into 20 latitude bands. Each latitude band is 8 degrees high, and is lettered starting
from "C" at 80°S, increasing up the English alphabet until "X", omitting the letters "I" and "O" (because of
their similarity to the numerals one and zero). 

> Note: The last latitude band, "X", is extended an extra 4 degrees,
so it ends at 84°N latitude, thus covering the northernmost land on Earth.

The combination of a zone and a latitude band defines a grid zone. The zone is always written first,
followed by the latitude band. For example, a position in Toronto, Ontario, Canada, would find itself in
zone 17 and latitude band "T", thus the full grid zone reference is "17T".

> Tip: Bands lower than "N" are in the southern hemisphere.

## See Also

- ``LocationFormatter/CoordinateFormat/utm``
