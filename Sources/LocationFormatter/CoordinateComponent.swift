import CoreLocation

public enum CoordinateType: Codable {
    case latitude, longitude
    
    /// Range of degrees supported by the ``CoordinateOrientation``.
    public var range: ClosedRange<CLLocationDegrees> {
        switch self {
        case .latitude:
            return -90.0 ... 90.0
        case .longitude:
            return -180.0 ... 180.0
        }
    }
    
}

public struct CoordinateComponent: Codable {
    let value: CLLocationDegrees
    let type: CoordinateType
    
    public init(_ value: CLLocationDegrees, type: CoordinateType) throws(ParsingError) {
        guard type.range.contains(value) else {
            throw .invalidRangeDegrees
        }
        self.type = type
        self.value = value
    }
    
    public var hemisphere: CoordinateHemisphere {
        switch type {
        case .latitude:
            return value >= .zero ? .north : .south
            
        case .longitude:
            return value >= .zero ? .east : .west
        }
    }
}
