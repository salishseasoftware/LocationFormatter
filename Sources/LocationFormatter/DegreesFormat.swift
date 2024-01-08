import Foundation

/// The format uses to represent a `CLLocationDegrees` value as a string.
enum DegreesFormat: String {
    
    /// Decimal Degrees (DD).
    case decimalDegrees
    
    /// Degrees and Decimal Minutes (DDM).
    case degreesDecimalMinutes
    
    /// Degrees, Minutes, Seconds (DMS).
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

// MARK: - CoordinateFormat support

extension DegreesFormat {
    init?(coordinateFormat: CoordinateFormat) {
        switch coordinateFormat {
        case .decimalDegrees:
            self = .decimalDegrees
        case .degreesDecimalMinutes:
            self = .degreesDecimalMinutes
        case .degreesMinutesSeconds:
            self = .degreesMinutesSeconds
        case .utm, .geoURI:
            return nil
        }
    }
    
    var coordinateFormat: CoordinateFormat {
        switch self {
        case .decimalDegrees:
            return .decimalDegrees
        case .degreesDecimalMinutes:
            return .degreesDecimalMinutes
        case .degreesMinutesSeconds:
            return .degreesMinutesSeconds
        }
    }
}
