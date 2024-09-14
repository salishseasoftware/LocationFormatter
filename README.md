[![Swift](https://github.com/salishseasoftware/LocationFormatter/actions/workflows/test.yml/badge.svg)](https://github.com/salishseasoftware/LocationFormatter/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/release/salishseasoftware/LocationFormatter/all.svg)](https://github.com/salishseasoftware/LocationFormatter/releases)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsalishseasoftware%2FLocationFormatter%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/salishseasoftware/LocationFormatter)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsalishseasoftware%2FLocationFormatter%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/salishseasoftware/LocationFormatter)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/github/license/salishseasoftware/LocationFormatter)](LICENSE)

# LocationFormatter

This package provides some Formatters that convert between coordinates and their textual representations.

## Usage

Please see [the documentation](https://www.salishseasoftware.com/LocationFormatter/documentation/locationformatter/) for more detailed usage instructions.


### LocationCoordinateFormatter

This is the primary formatter for converting coordinates. It utilizes additional formatters for specific formats.

LocationCoordinateFormatter provides a variety of configuration options for customizing both the string output and parsing coordinates from strings.


#### Converting coordinates to strings

```swift
import LocationFormatter

let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)

// Decimal Degrees (DD)
let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
formatter.string(from: coordinate) // "48.11638° N, 122.74231° W"

// Degrees Decimal Minutes (DDM)
let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
formatter.string(from: coordinate) // "48° 06.983′ N, 122° 46.516′ W"

// Degrees Minutes Seconds (DMS)
let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
formatter.string(from: coordinate) // "48° 6′ 59″ N, 122° 46′ 31″ W"

// Universal Trans Mercator (UTM)
let formatter = LocationCoordinateFormatter(format: .utm)
formatter.string(from: coordinate) // "10U 516726m E 5329260m N"
```

#### Converting strings to coordinates

```swift
import LocationFormatter


// Decimal Degrees (DD)
let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
try formatter.coordinate(from: "48.11638° N, 122.74231° W") // (48.11638, -122.77527)

// Degrees Decimal Minutes (DDM)
let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
try formatter.coordinate(from: "48° 06.983' N, 122° 46.516' W") // (48.11638, -122.77527)

// Degrees Minutes Seconds (DMS)
let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
try formatter.coordinate(from: "48° 6' 59\" N, 122° 46' 31\" W") // (48.11638, -122.77527)

// Universal Trans Mercator (UTM)
let formatter = LocationCoordinateFormatter(format: .utm)
try formatter.coordinate(from: "10U 516726m E 5329260m N") // (48.11638, -122.77527)
```

## Extensions

### String+Location

Extends `String` with a convenience function to parse a coordinate from a string using all supported format.

```swift
import Location

"48.11638 °N, 122.74231° W".coordinate() // (48.11638, -122.77527)
"48° 06.983' N, 122° 46.516' W".coordinate() // (48.11638, -122.77527)
"48° 6' 59\" N, 122° 46' 31\" W".coordinate() // (48.11638, -122.77527)
"10U 516726m E 5329260m N".coordinate() // (48.11638, -122.77527)
```

## Dependencies

### UTMConversion

- Provides support for converting between latitude/longitude and the [UTM (Universal Transverse Mercator)](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system) coordinate systems.
- License: [MIT](https://github.com/wtw-software/UTMConversion/blob/master/LICENSE)
- Repo: https://github.com/wtw-software/UTMConversion

### Swift Numerics

- Swift Numerics provides a set of modules that support numerical computing in Swift..
- License: [Apache License 2.0](https://github.com/apple/swift-numerics/blob/main/LICENSE.txt)
- Repo: https://github.com/apple/swift-numerics

