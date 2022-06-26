import Foundation

/// The format uses to represent a `CLLocationCoordinate2d` value as a string.
public enum CoordinateFormat: String {
    /// Decimal Degrees (DD).
    ///
    /// Commonly used on the web and computer systems.
    ///
    /// Example: `48.11638° N, 122.77527° W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case decimalDegrees
    /// Degrees and Decimal Minutes (DDM).
    ///
    /// Commonly used by electronic navigation equipment.
    ///
    /// - There are sixty minutes in a degree.
    /// - One minute of _latitude_, equals one nautical mile.
    ///
    /// Example: `48° 06.983' N, 122° 46.516' W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case degreesDecimalMinutes
    /// Degrees, Minutes, Seconds (DMS).
    ///
    /// Commonly seen on printed charts and maps.
    ///
    /// - There are sixty seconds in one minute.
    /// - There are sixty minutes in a degree.
    /// - One minute of _latitude_, equals one nautical mile.
    ///
    /// Example: `48° 6' 59" N, 122° 46' 31" W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case degreesMinutesSeconds
    /// Universal Transverse Mercator (UTM).
    ///
    /// Example: `10U 516726m E 5329260m N`.
    case utm
}

/// The format uses to represent a `CLLocationDegrees` value as a string.
public enum DegreesFormat: String {
    /// Decimal Degrees (DD).
    ///
    /// Commonly used on the web and computer systems.
    ///
    /// Example: `122.77527° W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case decimalDegrees
    /// Degrees and Decimal Minutes (DDM).
    ///
    /// Commonly used by electronic navigation equipment.
    ///
    /// - There are sixty minutes in a degree.
    /// - One minute of _latitude_, equals one nautical mile.
    ///
    /// Example: `122° 46.516' W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case degreesDecimalMinutes
    /// Degrees, Minutes, Seconds (DMS).
    ///
    /// Commonly seen on printed charts and maps.
    ///
    /// - There are sixty seconds in one minute.
    /// - There are sixty minutes in a degree.
    /// - One minute of _latitude_, equals one nautical mile.
    ///
    /// Example: `122° 46' 31" W`.
    ///
    /// - Note: The cardinal direction can be represented either as a signed number _or_ using a prefix (N, S, E, W).
    case degreesMinutesSeconds
        
    var regexPattern: String {
        switch self {
        case .decimalDegrees:
            return #"""
            (?x)
            (?# one of N, S, E, or W, optional)
            (?<PREFIX>[NSEW]?)
            \h?+
            (?# 1 to 3 digits, and 1 or more decimal places)
            (?<DEGREES>\-?\d{1,3}\.\d+)
            \h?+
            (?# one of N, S, E, or W, optional)
            (?<SUFFIX>[NSEW]?)
            \b
            """#
            
        case .degreesDecimalMinutes:
            return #"""
            (?x)
            (?# one of N, S, E, or W, optional)
            (?<PREFIX>[NSEW]?)
            \h?+
            (?# optional negative sign, then 1 to 3 digits)
            (?<DEGREES>\-?\d{1,3})
            \h
            (?# 1-2 digits, and 1 or more decimal places)
            (?<MINUTES>\d{1,2}\.\d+)
            \h?+
            (?# one of N, S, E, or W, optional)
            (?<SUFFIX>[NSEW]?)
            \b
            """#
            
        case .degreesMinutesSeconds:
            return #"""
            (?x)
            (?# One of N, S, E, or W, optional)
            (?<PREFIX>[NSEW]?)
            \h?+
            (?# Optional negative sign, then 1 to 3 digits)
            (?<DEGREES>\-?\d{1,3})
            \h
            (?# 1 -2 digits)
            (?<MINUTES>\d{1,2})
            \h
            (?# 1 to 2 digits)
            (?<SECONDS>\d{1,2}\.?\d*)
            \h?+
            (?# One of N, S, E, or W, optional)
            (?<SUFFIX>[NSEW]?)
            \b
            """#
        }
    }
}
