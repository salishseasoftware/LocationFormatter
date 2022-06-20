import CoreLocation

enum CoordinateHemisphere: String {
    case north = "N"
    case south = "S"
    case east  = "E"
    case west  = "W"

    var orientation: CoordinateOrientation {
        switch self {
        case .north, .south:
            return .latitude
        case .east, .west:
            return .longitude
        }
    }

    var range: ClosedRange<CLLocationDegrees> {
        switch self {
        case .north:
            return 0.0 ... 90.0
        case .south:
            return -90.0 ... 0.0
        case .east:
            return 0.0 ... 180.0
        case .west:
            return -180.0 ... 0.0
        }
    }

    func orientation(for _: CLLocationDegrees) -> CoordinateOrientation {
        switch self {
        case .north, .south:
            return .latitude
        case .east, .west:
            return .longitude
        }
    }
}
