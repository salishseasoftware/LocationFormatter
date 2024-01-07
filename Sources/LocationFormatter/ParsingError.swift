import Foundation
import CoreLocation

/// An error encountered when parsing a `CLLocationCoordinate2D`
/// or `CLLocationDegrees` value from a string.
public enum ParsingError: Error, Equatable {
    /// The suffix and prefix of the coordinate string contradict each other.
    case conflict
    
    /// The matched coordinate is not valid.
    case invalidCoordinate
    
    /// The expected orientation does not match the parsed direction.
    case invalidDirection
    
    /// The matched degrees is outside the expected range.
    case invalidRangeDegrees
    
    /// The matched minutes are outside the expected range.
    case invalidRangeMinutes

    /// The matched seconds are outside the expected range.
    case invalidRangeSeconds
    
    /// The parsed `UTMGridZone` is invalid.
    case invalidZone
    
    /// The parsed `UTMLatitudeBand` is invalid.
    case invalidLatitudeBand
    
    /// No match found
    case noMatch
    
    /// The named string was not found.
    case notFound(name: String)
    
    /// The named coordinate references system (CRS) is not supported.
    case unsupportedCoordinateReferenceSystem(crs: String)
}
