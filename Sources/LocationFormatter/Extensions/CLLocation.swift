import CoreLocation

extension CLLocation {
    /// Indicates the amount of uncertainty in the location as a value in meters.
    ///
    /// This is intended to correlate the `horizontalAccuracy` and `verticalAccuracy`
    /// properties of `CLLocation` to the `GeoURI` location uncertainty parameter defined
    /// in [section-3.4.3](https://datatracker.ietf.org/doc/html/rfc5870#section-3.4.3).
    ///
    /// A `nil` value indicates that the uncertainty is unknown.
    ///
    /// - Note: A value of zero has different meanings in `CoreLocation` and the `GeoURI` specification,
    /// so the implementations cannot match exactly.
    public var uncertainty: CLLocationAccuracy? {
        switch (horizontalUncertainty, verticalUncertainty) {
        case (.none, .none):
            return nil
        case (.some(let h), .none):
            return h
        case (.none, .some(let v)):
            return v
        case (.some(let h), .some(let v)):
            return max(h, v)
        }
    }
    
    var horizontalUncertainty: CLLocationAccuracy? {
        guard horizontalAccuracy > .zero else { return nil }
        return horizontalAccuracy
    }
    
    var verticalUncertainty: CLLocationAccuracy? {
        guard verticalAccuracy > .zero, altitude != .zero else { return nil }
        return verticalAccuracy
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

