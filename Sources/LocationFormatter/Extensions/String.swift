import CoreLocation
import Foundation

public extension String {
    /// Parses a coordinate value from a string.
    ///
    /// Attempts to recognize a valid coordinate in Decimal Degrees, Degrees Decimal Minutes,
    /// Degrees Minutes Seconds, or UTM formats.
    ///
    /// - Returns: the recognized coordinate value.
    func coordinate() -> CLLocationCoordinate2D?  {
        var coordinate: CLLocationCoordinate2D?

        let formatters: [LocationCoordinateFormatter] = [
            LocationCoordinateFormatter(format: .decimalDegrees),
            LocationCoordinateFormatter(format: .degreesDecimalMinutes),
            LocationCoordinateFormatter(format: .degreesMinutesSeconds),
            LocationCoordinateFormatter(format: .utm),
            LocationCoordinateFormatter(format: .geoURI),
        ]

        for formatter in formatters {
            if let coord = try? formatter.coordinate(from: self) {
                coordinate = coord
                break
            }
        }

        return coordinate
    }
}
