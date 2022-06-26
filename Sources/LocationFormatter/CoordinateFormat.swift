import Foundation

/// The format uses to represent a `CLLocationCoordinate2d` value as a string.
public enum CoordinateFormat: String {
    
    /// Decimal Degrees (DD).
    ///
    /// Commonly used on the web and computer systems.
    case decimalDegrees
    
    /// Degrees and Decimal Minutes (DDM).
    ///
    /// Commonly used by electronic navigation equipment.
    case degreesDecimalMinutes
    
     /// Degrees, Minutes, Seconds (DMS).
     ///
     /// This is the format commonly used on printed charts and maps.
    case degreesMinutesSeconds
    
    /// Universal Transverse Mercator (UTM).
    case utm
}

extension CoordinateFormat: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
