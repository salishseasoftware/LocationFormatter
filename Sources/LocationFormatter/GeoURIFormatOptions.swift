/// Options affecting how `CLLocation` objects are converted between their GeoURI representations.
public struct GeoURIFormatOptions: OptionSet {
    /// Normalize longitude values when converting between location objects and GeoURI strings.
    public static let normalizeLongitude = Self(rawValue: 1 << 0)
    /// Include the Coordinate Reference System (CRS) parameter in GeoURI strings representations.
    public static let includeCRS = Self(rawValue: 1 << 1)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
}
