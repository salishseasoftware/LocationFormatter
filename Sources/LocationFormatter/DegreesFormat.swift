import Foundation

public enum CoordinateFormat: String {
    /// Decimal Degrees (DD).
    case decimalDegrees
    /// Degrees, Decimal Minutes (DDM).
    case degreesDecimalMinutes
    /// Degrees, Minutes, Seconds (DMS).
    case degreesMinutesSeconds
    /// Universal Transverse Mercator (UTM).
    case utm
}

/// The format used by the receiver.
public enum DegreesFormat: String {
    /// Decimal Degrees (DD)
    ///
    /// Examples
    /// * `-114.012122`
    /// * `-114.012122°`
    /// * `114.012122° W`
    case decimalDegrees
    /// Degrees, Decimal Minutes (DDM)
    ///
    /// Examples
    /// * `-114 0.7273`
    /// * `-114° 0.7273'`
    /// * `114° 0.7273' W`
    case degreesDecimalMinutes
    /// Degrees, Minutes, Seconds (DMS)
    ///
    /// Examples
    /// * `-114 00 43.6398`
    /// * `-114° 00' 43.6398"`
    /// * `114° 00' 43.6398" W`
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
