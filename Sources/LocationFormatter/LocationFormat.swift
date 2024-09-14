import CoreLocation
@preconcurrency import RegexBuilder

struct LocationFormat {
    static let comma: Character = "\u{002C}"
    static let space: Character = "\u{0020}"
    
    
    static func components(from value: String) throws -> [String] {
        // Prefer comma if there is one
        let separator = value.contains(LocationFormat.comma) ? LocationFormat.comma : LocationFormat.space
        
        let components = value
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        guard components.count == 2 else { throw ParsingError.noMatch }
        
        return components
        
    }
    
    
    static func resolveDirection(prefix: String?, suffix: String?) throws -> CoordinateHemisphere? {
        switch (prefix, suffix) {
        case let (.some(prefix), .some(suffix)):
            guard prefix == suffix else { throw ParsingError.conflict }
            return CoordinateHemisphere(rawValue: prefix)
        case let (.some(prefix), .none):
            return CoordinateHemisphere(rawValue: prefix)
        case let (.none, .some(suffix)):
            return CoordinateHemisphere(rawValue: suffix)
        case (.none, .none):
            return nil
        }
    }
    
    static func normalize(degrees: CLLocationDegrees, minutes: Double?, seconds: Double?, orientation: CoordinateOrientation, inHemisphere hemisphere: CoordinateHemisphere?) throws -> CLLocationDegrees {
        var degrees = degrees
        var actualOrientation = orientation
        
        if let hemisphere {
            switch hemisphere {
            case .south, .west:
                if degrees > 0 { degrees.negate() }
            case .north, .east:
                if degrees < 0 { degrees.negate() }
            }
            
            if orientation != .unspecified {
                // Expected orientation does not match parsed direction
                guard orientation == hemisphere.orientation else { throw ParsingError.invalidDirection }
            }
            
            actualOrientation = hemisphere.orientation
        }
        
        if let minutes {
            let minutesAsDegrees = minutes / 60
            degrees += degrees < 0 ? -minutesAsDegrees : minutesAsDegrees
        }
        
        if let seconds {
            let secondsAsDegrees = seconds / 3600
            degrees += degrees < 0 ? -secondsAsDegrees : secondsAsDegrees
        }
        
        guard actualOrientation.range.contains(degrees) else {
            throw ParsingError.invalidRangeDegrees
        }
        
        return degrees
    }
    
    static let cardinalDirectionRegex = Optionally(.anyOf("NSEW"))
}


