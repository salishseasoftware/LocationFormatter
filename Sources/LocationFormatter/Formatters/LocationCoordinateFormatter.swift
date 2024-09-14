import CoreLocation
import UTMConversion

/**
 A formatter that converts between CLLocationCoordinate2d values and their textual representations.
 
 Instances of LocationCoordinateFormatter create string representations of `CLLocationCoordinate2D` values,
 and convert textual representations of coordinates into `CLLocationCoordinate2d` values.
 
 Formatting a coordinate using a format, a symbol style, and display options:
 ```swift
 let formatter = LocationCoordinateFormatter(
    format = .decimalDegrees,
    symbolStyle = .simple,
    displayOptions = [.suffix]
 )
 
 let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
 formatter.string(from: coordinate)
 // "48.11638° N, 122.77527° W"
 ```
 */
public final class LocationCoordinateFormatter: Formatter {
    
    /// Creates a new LocationCoordinateFormatter.
    /// - Parameters:
    ///   - format: The ``CoordinateFormat`` used to represent a `CLLocationDegrees` value as a string.
    ///   - symbolStyle: The ``SymbolStyle`` used to annotate coordinate components.
    ///   - displayOptions: The ``DisplayOptions`` for creating a textutal representation of a `CLLocationDegrees` value.
    ///   - parsingOptions: he ``ParsingOptions`` for parsing `CLLocationDegrees` values from strings.
    ///   - minimumDegreesFractionDigits: The minimum number of digits after the decimal separator for degrees.
    ///   - maximumDegreesFractionDigits: The maximum number of digits after the decimal separator for degrees.
    ///   - datum: The datum used with a UTM ``CoordinateFormat``. The default value is `WGS84`.
    public init(
        format: CoordinateFormat = .decimalDegrees,
        symbolStyle: SymbolStyle = .traditional,
        displayOptions: DisplayOptions = [.suffix],
        parsingOptions: ParsingOptions = [.caseInsensitive],
        minimumDegreesFractionDigits: Int = 1,
        maximumDegreesFractionDigits: Int = 5,
        datum: UTMDatum = .wgs84
    ) {
        self.format = format
        self.symbolStyle = symbolStyle
        self.displayOptions = displayOptions
        self.parsingOptions = parsingOptions
        self.minimumDegreesFractionDigits = minimumDegreesFractionDigits
        self.maximumDegreesFractionDigits = maximumDegreesFractionDigits
        self.datum = datum

        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    
    /// Returns a string containing the formatted value of the provided coordinate.
    public func string(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            return degreeString(from: coordinate)
        case .utm:
            return utmFormatter.string(from: coordinate)
        case .geoURI:
            return geoUriFormatter.string(fromCoordinate: coordinate)
        }
    }

    /// Returns a coordinate created by parsing a given string.
    public func coordinate(from string: String) throws -> CLLocationCoordinate2D {
        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            return try coordinateFrom(degreesString: string)
        case .utm:
            return try utmFormatter.coordinate(from: string)
        case .geoURI:
            return try geoUriFormatter.coordinate(from: string)
        }
    }

    /// Returns a string containing the formatted latitude of the provided coordinate.
    public func latitudeString(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
        return degreesFormatter.string(from: coordinate.latitude, orientation: .latitude)
    }

    /// Returns a string containing the formatted longitude of the provided coordinate.
    public func longitudeString(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
        return degreesFormatter.string(from: coordinate.longitude, orientation: .longitude)
    }

    /// Returns an CLLocation object created by parsing a given string.
    public func location(from str: String) throws -> CLLocation {
        let coord = try coordinate(from: str)
        return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
    }
    
    // MARK: - Internal

    /// The coordinate format used by the receiver.
    let format: CoordinateFormat
    
    /// Options for display
    ///
    /// Default options include `DisplayOptions.suffix`.`
    let displayOptions: DisplayOptions
    
    /// Options for parsing degree values from strings.
    ///
    /// Default options include `ParsingOptions.caseInsensitive`.`
    let parsingOptions: ParsingOptions
    

    /// The minimum number of digits after the decimal separator for degrees.
    ///
    /// Default value is 1.
    ///
    /// - Important: Only applicable if `format` is `CoordinateFormat.decimalDegrees`.
    let minimumDegreesFractionDigits: Int

    /// The maximum number of digits after the decimal separator for degrees.
    ///
    /// Default is 5, which is accurate to 1.1132 meters (3.65 feet).
    ///
    ///  - Important: Only applicable if `format` is `CoordinateFormat.decimalDegrees`.
    let maximumDegreesFractionDigits: Int

    /// Defines the characters used to annotate coordinate components.
    let symbolStyle: SymbolStyle

    /// The datum to use for UTM coordinates.
    ///
    /// Default value is WGS84.
    ///
    /// - Important: Only used when the ``format`` is `utm`.
    let datum: UTMDatum

    // MARK: - Private

    private func degreeString(from coordinate: CLLocationCoordinate2D) -> String? {
        guard let lat = latitudeString(from: coordinate), let lon = longitudeString(from: coordinate) else {
            return nil
        }
        return "\(lat), \(lon)"
    }

    private func coordinateFrom(degreesString string: String) throws -> CLLocationCoordinate2D {
        let comma: Character = "\u{002C}"
        let space: Character = "\u{0020}"

        // Prefer comma if we have one
        let separator: Character = string.contains(comma) ? comma : space

        let components = string
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        guard components.count == 2 else { throw ParsingError.noMatch }

        let lat = try degreesFormatter.locationDegrees(from: components[0], orientation: .latitude)
        let lon = try degreesFormatter.locationDegrees(from: components[1], orientation: .longitude)

        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        guard CLLocationCoordinate2DIsValid(coord) else {
            throw ParsingError.invalidCoordinate
        }

        return coord
    }

    // MARK: - Formatter

    override public func string(for obj: Any?) -> String? {
        guard let coordinate = obj as? CLLocationCoordinate2D else { return nil }
        return string(from: coordinate)
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        do {
            obj?.pointee = try location(from: string)
            return true
        } catch let err {
            error?.pointee = err.localizedDescription as NSString
            return false
        }
    }
    
    // MARK: - Formatters
    
    private lazy var degreesFormatter = LocationDegreesFormatter(
        format: format,
        symbolStyle: symbolStyle,
        displayOptions: displayOptions,
        parsingOptions: parsingOptions,
        minimumDegreesFractionDigits: minimumDegreesFractionDigits,
        maximumDegreesFractionDigits: maximumDegreesFractionDigits
    )
    
    private lazy var utmFormatter = UTMCoordinateFormatter(
        displayOptions: displayOptions,
        parsingOptions: parsingOptions,
        datum: datum
    )
    
    private lazy var geoUriFormatter = GeoURILocationFormatter(
        parsingOptions: parsingOptions
    )
}

public extension LocationCoordinateFormatter {
    /// Simple decimal format (46.853063, -114.012122)
    @MainActor
    static let decimalFormatter = LocationCoordinateFormatter(
        format: .decimalDegrees,
        symbolStyle: .none,
        displayOptions: []
    )

    /**
     A LocationCoordinateFormatter configured to use decimal degrees (DD) format.
     
    ```swift
    let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
    let formatter = LocationCoordinateFormatter.decimalDegreesFormatter
    formatter.string(from: coordinate)
    // "48.11638° N, 122.77527° W"
    ```
     */
    @MainActor 
    static let decimalDegreesFormatter = LocationCoordinateFormatter()

    /**
     A LocationCoordinateFormatter configured to use degrees decimal minutes (DDM) format.
     
    ```swift
    let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
    let formatter = LocationCoordinateFormatter.degreesDecimalMinutesFormatter
    formatter.string(from: coordinate)
    // "48° 06.983' N, 122° 46.516' W"
    ```
     */
    @MainActor 
    static let degreesDecimalMinutesFormatter = LocationCoordinateFormatter(
        format: .degreesDecimalMinutes,
        symbolStyle: .simple,
        displayOptions: [.suffix]
    )

    /**
     A LocationCoordinateFormatter configured to use degrees minutes seconds (DMS) format.
     
    ```swift
    let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
    let formatter = LocationCoordinateFormatter.degreesMinutesSecondsFormatter
    formatter.string(from: coordinate)
    // "48° 6' 59" N, 122° 46' 31" W"
    ```
     */
    @MainActor 
    static let degreesMinutesSecondsFormatter = LocationCoordinateFormatter(
        format: .degreesMinutesSeconds,
        symbolStyle: .simple,
        displayOptions: [.suffix]
    )

    /**
     A LocationCoordinateFormatter configured to use universal trans mercator (UTM) format.
    
   ```swift
   let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
   let formatter = LocationCoordinateFormatter.utmFormatter
   formatter.string(from: coordinate)
   // "10U 516726m E 5329260m N"
   ```
    */
    @MainActor
    static let utmFormatter = LocationCoordinateFormatter(format: .utm)
    
    /**
     A LocationCoordinateFormatter configured to use the GeoURI format.
    
   ```swift
   let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
   let formatter = LocationCoordinateFormatter.geoUriFormatter
   formatter.string(from: coordinate)
   // "geo:48.11638,-122.77527"
   ```
    */
    @MainActor 
    static let geoUriFormatter = LocationCoordinateFormatter(format: .geoURI)
}
