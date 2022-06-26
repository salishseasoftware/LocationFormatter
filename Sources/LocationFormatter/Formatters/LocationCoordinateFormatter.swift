import CoreLocation
import UTMConversion

/**
 A formatter that converts between CLLocationCoordinate2d values and their textual representations.
 
 Instances of LocationCoordinateFormatter create string representations of `CLLocationCoordinate2D` values,
 and convert textual representations of coordinates into `CLLocationCoordinate2d` values.
 
 Formatting a coordinate using a format and symbol style:
 ```swift
 let formatter = LocationCoordinateFormatter()
 formatter.format = .decimalDegrees
 formatter.symbolStyle = .simple
 format.displayOptions = [.suffix]
 
 let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
 formatter.string(from: coordinate)
 // "48.11638° N, 122.77527° W"
 ```
 */
public final class LocationCoordinateFormatter: Formatter {
    
    public init(format: CoordinateFormat = .decimalDegrees,
                displayOptions: DisplayOptions = [.suffix],
                parsingOptions: ParsingOptions = [.caseInsensitive]) {
        self.format = format
        self.displayOptions = displayOptions
        self.parsingOptions = parsingOptions

        super.init()

        updateFormat()
        updateDisplayOptions()
        updateParsingOptions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var degreesFormatter = LocationDegreesFormatter()
    private lazy var utmFormatter = UTMCoordinateFormatter()

    // MARK: - Configuration

    /// The coordinate format used by the receiver.
    public var format: CoordinateFormat {
        didSet { updateFormat() }
    }

    /// Options for the string representation.
    public var displayOptions: DisplayOptions = [] {
        didSet { updateDisplayOptions() }
    }

    /// Options that control the parsing behavior.
    public var parsingOptions: ParsingOptions = [] {
        didSet { updateParsingOptions() }
    }

    /// The minimum number of digits after the decimal separator for degrees.
    ///
    /// Default value is 1.
    ///
    /// - Important: Only applicable if `format` is `CoordinateFormat.decimalDegrees`.
    public var minimumDegreesFractionDigits: Int {
        get { degreesFormatter.minimumDegreesFractionDigits }
        set { degreesFormatter.minimumDegreesFractionDigits = newValue }
    }

    /// The maximum number of digits after the decimal separator for degrees.
    ///
    /// Default is 5, which is accurate to 1.1132 meters (3.65 feet).
    ///
    ///  - Important: Only applicable if `format` is `CoordinateFormat.decimalDegrees`.
    public var maximumDegreesFractionDigits: Int {
        get { degreesFormatter.maximumDegreesFractionDigits }
        set { degreesFormatter.maximumDegreesFractionDigits = newValue }
    }

    /// Defines the characters used to annotate coordinate components.
    public var symbolStyle: SymbolStyle {
        get { degreesFormatter.symbolStyle }
        set { degreesFormatter.symbolStyle = newValue }
    }

    /// The datum to use for UTM coordinates.
    ///
    /// Default value is WGS84.
    ///
    /// - Important: Only used when the ``format`` is `utm`.
    public var utmDatum: UTMDatum {
        get { utmFormatter.datum }
        set { utmFormatter.datum = newValue }
    }

    // MARK: - Public API
    
    /// Returns a string containing the formatted value of the provided coordinate.
    public func string(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            return degreeString(from: coordinate)
        case .utm:
            return utmFormatter.string(from: coordinate)
        }
    }

    /// Returns a coordinate created by parsing a given string.
    public func coordinate(from string: String) throws -> CLLocationCoordinate2D {
        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            return try coordinateFrom(degreesString: string)
        case .utm:
            return try utmFormatter.coordinate(from: string)
        }
    }

    /// Returns a string containing the formatted latitude of the provided coordinate.
    public func latitudeString(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
        degreesFormatter.orientation = .latitude
        return degreesFormatter.string(from: coordinate.latitude)
    }

    /// Returns a string containing the formatted longitude of the provided coordinate.
    public func longitudeString(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
        degreesFormatter.orientation = .longitude
        return degreesFormatter.string(from: coordinate.longitude)
    }

    /// Returns an CLLocation object created by parsing a given string.
    public func location(from str: String) throws -> CLLocation {
        let coord = try coordinate(from: str)
        return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
    }

    // MARK: - Private
    
    private func updateFormat() {
        switch format {
        case .decimalDegrees:
            degreesFormatter.format = .decimalDegrees
        case .degreesDecimalMinutes:
            degreesFormatter.format = .degreesDecimalMinutes
        case .degreesMinutesSeconds:
            degreesFormatter.format = .degreesMinutesSeconds
        case .utm:
            break
        }
    }

    private func updateDisplayOptions() {
        var options: DisplayOptions = []
        if displayOptions.contains(.suffix) { options.insert(.suffix) }
        if displayOptions.contains(.compact) { options.insert(.compact) }

        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            degreesFormatter.displayOptions = options
        case .utm:
            utmFormatter.displayOptions = options
        }
    }

    private func updateParsingOptions() {
        var options: ParsingOptions = []
        if parsingOptions.contains(.caseInsensitive) { options.insert(.caseInsensitive) }
        if parsingOptions.contains(.trimmed) { options.insert(.trimmed) }

        switch format {
        case .decimalDegrees, .degreesDecimalMinutes, .degreesMinutesSeconds:
            degreesFormatter.parsingOptions = options
        case .utm:
            utmFormatter.parsingOptions = options
        }
    }

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
}

public extension LocationCoordinateFormatter {
    /// Simple decimal format (46.853063, -114.012122)
    static let decimalFormatter: LocationCoordinateFormatter = {
        let formatter = LocationCoordinateFormatter()
        formatter.format = .decimalDegrees
        formatter.symbolStyle = .none
        formatter.displayOptions = []
        return formatter
    }()

    /// A LocationCoordinateFormatter configured to use decimal degrees (DD) format.
    static let decimalDegreesFormatter = LocationCoordinateFormatter(format: .decimalDegrees)

    /// A LocationCoordinateFormatter configured to use degrees decimal minutes (DDM) format.
    static let degreesDecimalMinutesFormatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)

    /// A LocationCoordinateFormatter configured to use degrees minutes seconds (DMS) format.
    static let degreesMinutesSecondsFormatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)

    /// A LocationCoordinateFormatter configured to use universal trans mercator (UTM) format.
    static let utmFormatter = LocationCoordinateFormatter(format: .utm)
}
