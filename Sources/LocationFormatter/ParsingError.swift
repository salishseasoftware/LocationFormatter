import Foundation

public enum ParsingError: Error, Equatable {
    case conflict
    case invalidCoordinate
    case invalidDirection
    case invalidRangeDegrees
    case invalidRangeMinutes
    case invalidRangeSeconds
    
    // UTM
    case invalidZone
    case invalidLatitudeBand
    
    case noMatch
    case notFound(name: String)
}

