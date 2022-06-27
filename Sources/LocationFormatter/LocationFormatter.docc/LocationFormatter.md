# ``LocationFormatter``

This package provides some Formatters that convert between coordinates and their textual representations.

## Overview

The ``LocationCoordinateFormatter`` can be configured to use a specific ``CoordinateFormat``, ``SymbolStyle``, and other ``DisplayOptions``. 

It in turn makes use of either a ``LocationDegreesFormatter``, or a  ``UTMCoordinateFormatter``, depending on the ``CoordinateFormat``.

Coordinates can be parsed from strings in any ``CoordinateFormat``, and according to configured  ``ParsingOptions``.


## Topics

### Formatters

- ``LocationCoordinateFormatter``
- ``LocationDegreesFormatter``
- ``UTMCoordinateFormatter``

### Display configuration

- ``CoordinateFormat``
- ``SymbolStyle``
- ``DisplayOptions``

### Parsing configuration

- ``LocationFormatter/ParsingOptions``
- ``LocationFormatter/ParsingError``
