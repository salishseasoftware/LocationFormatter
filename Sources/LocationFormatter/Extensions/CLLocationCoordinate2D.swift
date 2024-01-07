import CoreLocation

public extension CLLocationCoordinate2D {
    
    /// A CLLocationCoordinate2D with both a latitude and longitude of 0.0. 
    static let zero = Self(latitude: Double.zero, longitude: Double.zero)
    
    /**
     Null Island is the point on the Earth's surface at zero degrees latitude and zero degrees
     longitude (0°N 0°E), i.e., where the prime meridian and the equator intersect.
     
     Null Island is located in international waters in the Atlantic Ocean, roughly 600 km off the coast of West Africa, in the Gulf of Guinea.
     
     The exact point, using the WGS84 datum, is marked by the Soul buoy (named after the musical genre), a permanently-moored weather buoy.

     The term "Null Island" jokingly refers to the suppositional existence of an island at
     that location, and to a common cartographic placeholder name to which coordinates
     erroneously set to 0,0 are assigned in place-name databases in order to more easily find
     and fix them. The nearest land (4°45′30″N 1°58′33″W) is 570 km (354 mi; 307.8 nm) to the
     north – a small Ghanaian islet offshore from Achowa Point between Akwidaa and Dixcove.
     The depth of the seabed beneath the Soul buoy is around 4,940 meters (16,210 ft).
     */
    static let nullIsland = Self.zero
    
    /**
     Point Nemo (A.K.A. The oceanic pole of inaccessibility) is the place in the ocean that is farthest from land.
     
     It lies in the South Pacific Ocean, 2,704.8 km (1,680.7 mi) from the nearest lands: Ducie
     Island (part of the Pitcairn Islands) to the north, Motu Nui (part of the Easter Islands)
     to the northeast, and Maher Island (near the larger Siple Island, off the coast of Marie
     Byrd Land, Antarctica) to the south.
     
     The area is so remote that — as with any location more than 400 kilometers (about 250
     miles) from an inhabited area — sometimes the closest human beings are astronauts aboard
     the International Space Station when it passes overhead.
    */
    static let pointNemo = Self(latitude: -49.0273, longitude: -123.4345)
    
    /// Returns a new CLLocationCoordinate2D with a "normalized" longitude value.
    ///
    /// These transformations ate based on those defined in the [URI Comparison](https://datatracker.ietf.org/doc/html/rfc5870#section-3.4.4)
    /// section of the `GeoURI` specification.
    ///
    /// - Longitude values corresponding to the international dateline (-180° and 180°) will be represented as 180.0, 
    /// as they both identify the same physical longitude.
    /// - The longitude values of polar locations, 90° or -90° latitude, will be converted to 0.0 as all longitudes are 0° at the poles.
    func normalized() -> CLLocationCoordinate2D {
        // International dateline - -180 and 180 are identical, so prefer 180.
        var normalizedLongitude = longitude == -180.0 ? 180.0 : longitude
        // longitude is zero at the poles
        if latitude == -90.0 || latitude == 90.0 {
            normalizedLongitude = .zero
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: normalizedLongitude)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        LocationCoordinateFormatter.decimalFormatter.string(from: self) ?? ""
    }
}
