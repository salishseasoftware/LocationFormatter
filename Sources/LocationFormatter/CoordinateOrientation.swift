import CoreLocation

/// Defines whether a `CLLocationDegrees` is intended to represent latitude or longitude.
public enum CoordinateOrientation {
    /// Unspecified.
    case none
    /// The coordinate represents a latitude.
    case latitude
    /// The coordinate represents a longitude.
    case longitude
    
    /// Range of degrees supported by the ``CoordinateOrientation``.
    var range: ClosedRange<CLLocationDegrees> {
        switch self {
        case .latitude:
            return -90.0 ... 90.0
        case .longitude, .none:
            return -180.0 ... 180.0
        }
    }
    
    /// The hemisphere of the supplied degrees for this orientation.
    /// - Parameter degrees: A `CLLocationDegrees` value.
    /// - Returns: The corresponding ``CoordinateHemisphere`` value, or `nil` if the degrees is outside the range of the ``CoordinateOrientation``.
    func hemisphere(for degrees: CLLocationDegrees) -> CoordinateHemisphere? {
        switch self {
        case .latitude:
            guard (-90.0 ... 90.0).contains(degrees) else { return nil }
            return degrees >= 0.0 ? .north : .south

        case .longitude:
            guard (-180.0 ... 180.0).contains(degrees) else { return nil }
            return degrees >= 0.0 ? .east : .west
        case .none:
            return nil
        }
    }
}
