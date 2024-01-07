# ``LocationFormatter/GeoURILocationFormatter``

## Examples

A basic GeoURI containing a two dimensional coordinate:
```
geo:48.11638,-122.77527
```

A three dimensional coordinate:
```
geo:48.11638,-122.77527
```

Parameters that represent the coordinate reference system (crs) and uncertainty (u):
```
geo:11.373333,142.591667,-10920;crs=wgs84;u=10
```

## Topics

### Configuring Formatter Behavior and Style

- ``GeoURIFormatOptions``
- ``ParsingOptions``

### Parsing a GeoURI string.

- ``GeoURILocationFormatter/location(from:)``
- ``GeoURILocationFormatter/coordinate(from:)``

###  Generating a GeoURI string.

- ``GeoURILocationFormatter/string(fromLocation:)``
- ``GeoURILocationFormatter/string(fromCoordinate:)``

### Formatter methods

- ``GeoURILocationFormatter/string(for:)``
- ``GeoURILocationFormatter/getObjectValue(_:for:errorDescription:)``

### Errors

- ``ParsingError``
