import CoreLocation

/// A formatter that converts between location degrees and their textual representations.
///
/// Instances of LocationDegreesFormatter create string representations of CLLocationDegrees, and convert
/// textual representations of latitudes or longitudes into CLLocationDegrees instances.
/// For user-visible representations of latitudes and longitudes, LocationDegreesFormatter provides a variety of
/// configuration options.
public final class LocationDegreesFormatter: Formatter {
    
    override public init() {
        format = .decimalDegrees
        super.init()
    }

    public init(format: DegreesFormat, displayOptions: DisplayOptions = []) {
        self.format = format
        self.displayOptions = displayOptions
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    /// Defines whether a coordinate is intended to represent latitude or longitude. Default is `.none`.
    public var orientation: CoordinateOrientation = .none
    /// The format used by the receiver.
    public var format: DegreesFormat
    /// The minimum number of digits after the decimal separator for degrees. Default is 1.
    public var minimumDegreesFractionDigits = 1
    /// The maximum number of digits after the decimal separator for degrees.
    /// Default is 5, which is accurate to 1.1132 meters (3.65 feet).
    public var maximumDegreesFractionDigits = 5
    /// Defines the characters used to annotate coordinate components.
    public var symbolStyle: SymbolStyle = .simple
    /// Options for display
    public var displayOptions: DisplayOptions = [.suffix]
    /// Options for parsing coordinates strings
    public var parsingOptions: ParsingOptions = [.caseInsensitive]

    // MARK: - Public

    /// Returns a string containing the formatted value of the provided ``CLLocationDegrees``.
    public func string(from: CLLocationDegrees) -> String? {
        var degrees = from

        guard orientation.range.contains(degrees) else { return nil }

        let hemisphere = orientation.hemisphere(for: degrees)

        if displayOptions.contains(.suffix), hemisphere != nil { degrees = abs(degrees) }

        let minutes = (abs(degrees) * 60.0).truncatingRemainder(dividingBy: 60.0)
        let seconds = (abs(degrees) * 3600.0).truncatingRemainder(dividingBy: 60.0)

        var components: [String] = []

        switch format {
        case .decimalDegrees:
            let deg = degreesFormatter.string(from: NSNumber(value: degrees)) ?? "\(degrees)"
            components = ["\(deg)\(symbolStyle.degrees)"]

        case .degreesDecimalMinutes:
            let deg = Int(degrees >= 0 ? floor(degrees) : ceil(degrees))
            let min = minutesFormatter.string(from: NSNumber(value: minutes)) ?? "\(minutes)"
            components = ["\(deg)\(symbolStyle.degrees)",
                          "\(min)\(symbolStyle.minutes)"]

        case .degreesMinutesSeconds:
            let deg = Int(degrees >= 0 ? floor(degrees) : ceil(degrees))
            let min = Int(floor(minutes))
            let sec = Int(round(seconds))
            components = ["\(deg)\(symbolStyle.degrees)",
                          "\(min)\(symbolStyle.minutes)",
                          "\(sec)\(symbolStyle.seconds)"]
        }

        if displayOptions.contains(.suffix), let suffix = hemisphere?.rawValue {
            components.append(suffix)
        }

        return components.joined(separator: isCompact ? "" : " ")
    }

    /// Parse a CLLocationDegrees for a given string.
    /// - Parameters:
    ///   - str: The string to be parsed.
    ///   - orientation: Expected orientation (latitude or longitude). Optional, default is none.
    /// - Returns: a `CLLocationDegrees`.
    public func locationDegrees(from str: String, orientation: CoordinateOrientation? = nil) throws -> CLLocationDegrees {
        if let orientation = orientation {
            self.orientation = orientation
        }

        let degrees = try number(for: str).doubleValue
        guard self.orientation.range.contains(degrees) else { throw ParsingError.invalidRangeDegrees }
        return degrees
    }

    // MARK: - Formatter

    override public func string(for obj: Any?) -> String? {
        guard let degrees = obj as? CLLocationDegrees else { return nil }
        return string(from: degrees)
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        do {
            obj?.pointee = try number(for: string)
            return obj?.pointee != nil
        } catch let err {
            error?.pointee = err.localizedDescription as NSString
            return false
        }
    }

    // MARK: - Private

    private var isCompact: Bool {
        // cant be compact if not using symbols
        displayOptions.contains(.compact) && symbolStyle != .none
    }

    private func degrees(inResult result: NSTextCheckingResult, for string: String) throws -> Double {
        let degrees = try doubleValue(forName: "DEGREES", inResult: result, for: string)
        guard orientation.range.contains(degrees) else { throw ParsingError.invalidRangeDegrees }
        return degrees
    }

    private func minutes(inResult result: NSTextCheckingResult, for string: String) throws -> Double {
        let minutes = try doubleValue(forName: "MINUTES", inResult: result, for: string)
        guard (0.0 ..< 60.0).contains(minutes) else { throw ParsingError.invalidRangeMinutes }
        return minutes
    }

    private func seconds(inResult result: NSTextCheckingResult, for string: String) throws -> Double {
        let seconds = try doubleValue(forName: "SECONDS", inResult: result, for: string)
        guard (0.0 ..< 60.0).contains(seconds) else { throw ParsingError.invalidRangeSeconds }
        return seconds
    }

    private func directionPrefix(inResult result: NSTextCheckingResult,
                                 for string: String) throws -> CoordinateHemisphere {
        return try direction(inResult: result, forName: "PREFIX", inString: string)
    }

    private func directionSuffix(inResult result: NSTextCheckingResult,
                                 for string: String) throws -> CoordinateHemisphere {
        return try direction(inResult: result, forName: "SUFFIX", inString: string)
    }

    private func direction(inResult result: NSTextCheckingResult,
                           forName name: String,
                           inString string: String) throws -> CoordinateHemisphere {
        let val = try value(forName: name, inResult: result, for: string)
        guard let direction = CoordinateHemisphere(rawValue: val.uppercased()) else {
            throw ParsingError.notFound(name: name)
        }
        return direction
    }

    private func resolveDirection(inResult result: NSTextCheckingResult,
                                  for string: String) throws -> CoordinateHemisphere? {
        let directions = (try? directionPrefix(inResult: result, for: string),
                          try? directionSuffix(inResult: result, for: string))

        switch directions {
        case let (.some(prefix), .some(suffix)):
            guard prefix == suffix else { throw ParsingError.conflict }
            return suffix
        case let (.some(prefix), .none):
            return prefix
        case let (.none, .some(suffix)):
            return suffix
        case (.none, .none):
            return nil
        }
    }

    /// Returns a number object representing the location degrees recognized in the supplied string.
    private func number(for string: String) throws -> NSNumber {
        let str = string.desymbolized()

        var options: NSRegularExpression.Options = [.useUnicodeWordBoundaries]
        if parsingOptions.contains(.caseInsensitive) { options.insert(.caseInsensitive) }
        let regex = try NSRegularExpression(pattern: format.regexPattern, options: options)

        let nsRange = NSRange(str.startIndex ..< str.endIndex, in: str)
        guard let match = regex.firstMatch(in: str, options: [.anchored], range: nsRange) else {
            throw ParsingError.noMatch
        }

        var degrees = try self.degrees(inResult: match, for: str)
        var actualOrientation = orientation
        let direction: CoordinateHemisphere? = try resolveDirection(inResult: match, for: str)

        if let direction = direction {
            switch direction {
            case .south, .west:
                if degrees > 0 { degrees.negate() }
            case .north, .east:
                if degrees < 0 { degrees.negate() }
            }

            if orientation != .none {
                // Expected orientation does not match parsed direction
                guard orientation == direction.orientation else { throw ParsingError.invalidDirection }
            }

            actualOrientation = direction.orientation
        }

        if [DegreesFormat.degreesDecimalMinutes, DegreesFormat.degreesMinutesSeconds].contains(format) {
            let minutes = try self.minutes(inResult: match, for: str)
            let minutesAsDegrees = (minutes / 60)
            degrees += degrees < 0 ? -minutesAsDegrees : minutesAsDegrees
        }

        if format == .degreesMinutesSeconds {
            let seconds = try self.seconds(inResult: match, for: str)
            let secondsAsDegrees = (seconds / 3600)
            degrees += degrees < 0 ? -secondsAsDegrees : secondsAsDegrees
        }

        guard actualOrientation.range.contains(degrees) else { throw ParsingError.invalidRangeDegrees }

        return NSNumber(value: degrees.roundedTo(places: maximumDegreesFractionDigits))
    }

    // MARK: - Formatters

    lazy var degreesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumDegreesFractionDigits
        formatter.maximumFractionDigits = maximumDegreesFractionDigits
        return formatter
    }()

    lazy var minutesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        formatter.paddingCharacter = "0"
        formatter.paddingPosition = .afterPrefix
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        return formatter
    }()
}
