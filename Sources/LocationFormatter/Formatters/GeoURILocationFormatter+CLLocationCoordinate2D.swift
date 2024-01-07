import CoreLocation

extension GeoURILocationFormatter {
    /// Returns a `GeoURI` string representation of the provided `CLLocationCoordinate2D`.
    public func string(fromCoordinate coordinate: CLLocationCoordinate2D) -> String? {
        let location = CLLocation(coordinate: coordinate)
        return string(fromLocation: location)
    }
    
    /// Returns a `CLLocationCoordinate2D` created by parsing a `GeoURI` string.
    ///
    /// A ``ParsingError`` is thrown if the string is not a valid GeoURI.
    public func coordinate(from string: String) throws -> CLLocationCoordinate2D {
        try location(from: string).coordinate
    }
}
