import CoreLocation

/**
 A formatter that converts between `CLLocationDegrees` values and their textual representations.
 
 Instances of LocationDegreesFormatter create string representations of `CLLocationDegrees` values,
 and convert textual representations of degrees into `CLLocationDegrees` values.
 
 Formatting a degree using a format, a symbol style, and display options:
 ```swift
 let formatter = LocationDegreesFormatter(
    format = .decimalDegrees,
    symbolStyle = .simple,
    displayOptions = [.suffix]
 )
 
 formatter.string(from: -122.77527)
 // "122.77527° W"
 ```
 */
public final class LocationDegreesFormatter: Formatter {
    
    /// Creates a new LocationDegreesFormatter.
    /// - Parameters:
    ///   - format: The ``CoordinateFormat`` used to represent a `CLLocationDegrees` value as a string.
    ///   - symbolStyle: The ``SymbolStyle`` used to annotate coordinate components.
    ///   - displayOptions: The ``DisplayOptions`` for creating a textutal representation of a `CLLocationDegrees` value.
    ///   - parsingOptions: The ``ParsingOptions`` for parsing `CLLocationDegrees` values from strings.
    ///   - minimumDegreesFractionDigits: The minimum number of digits after the decimal separator for degrees.
    ///   - maximumDegreesFractionDigits: The maximum number of digits after the decimal separator for degrees.
    public init(
        format: CoordinateFormat = .decimalDegrees,
        symbolStyle: SymbolStyle = .traditional,
        displayOptions: DisplayOptions = [.suffix],
        parsingOptions: ParsingOptions = [.caseInsensitive],
        minimumDegreesFractionDigits: Int = 1,
        maximumDegreesFractionDigits: Int = 5
    ) {
        self.degreesFormat = DegreesFormat(coordinateFormat: format) ?? .decimalDegrees
        self.symbolStyle = symbolStyle
        self.displayOptions = displayOptions
        self.parsingOptions = parsingOptions
        self.minimumDegreesFractionDigits = minimumDegreesFractionDigits
        self.maximumDegreesFractionDigits = maximumDegreesFractionDigits
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public

    /// Returns a string containing the formatted value of the provided `CLLocationDegrees`.
    public func string(from: CLLocationDegrees, orientation: CoordinateOrientation = .unspecified) -> String? {
        var degrees = from

        guard orientation.range.contains(degrees) else { return nil }

        let hemisphere = orientation.hemisphere(for: degrees)

        if displayOptions.contains(.suffix), hemisphere != nil { degrees = abs(degrees) }

        let minutes = (abs(degrees) * 60.0).truncatingRemainder(dividingBy: 60.0)
        let seconds = (abs(degrees) * 3600.0).truncatingRemainder(dividingBy: 60.0)

        var components: [String] = []

        switch degreesFormat {
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
    public func locationDegrees(from str: String, orientation: CoordinateOrientation = .unspecified) throws -> CLLocationDegrees {
        let degrees = try number(for: str, orientation: orientation).doubleValue
        guard orientation.range.contains(degrees) else {
            throw ParsingError.invalidRangeDegrees
        }
        return degrees
    }

    // MARK: - Formatter

    override public func string(for obj: Any?) -> String? {
        guard let degrees = obj as? CLLocationDegrees else { return nil }
        return string(from: degrees, orientation: .unspecified)
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        do {
            obj?.pointee = try number(for: string, orientation: .unspecified)
            return obj?.pointee != nil
        } catch let err {
            error?.pointee = err.localizedDescription as NSString
            return false
        }
    }
    
    // MARK: - Internal
    
    /// The format uses to represent a CLLocationDegrees value as a string.
    let degreesFormat: DegreesFormat
    
    /// The ``SymbolStyle`` used to annotate coordinate components.
    let symbolStyle: SymbolStyle
    
    /// Options for display
    ///
    /// Default options include `DisplayOptions.suffx`.`
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
    
    /// The coordinate format used by the receiver.
    var coordinateFormat: CoordinateFormat {
        degreesFormat.coordinateFormat
    }
    
    var isCompact: Bool {
        // cant be compact if not using symbols
        displayOptions.contains(.compact) && symbolStyle != .none
    }

    // MARK: - Private
    
    private func degrees(inResult result: NSTextCheckingResult, for string: String, orientation: CoordinateOrientation) throws -> Double {
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
    private func number(for string: String, orientation: CoordinateOrientation) throws -> NSNumber {
        let str = string.desymbolized()

        var options: NSRegularExpression.Options = [.useUnicodeWordBoundaries]
        if parsingOptions.contains(.caseInsensitive) { options.insert(.caseInsensitive) }
        let regex = try NSRegularExpression(pattern: degreesFormat.regexPattern, options: options)

        let nsRange = NSRange(str.startIndex ..< str.endIndex, in: str)
        guard let match = regex.firstMatch(in: str, options: [.anchored], range: nsRange) else {
            throw ParsingError.noMatch
        }

        var degrees = try self.degrees(inResult: match, for: str, orientation: orientation)
        var actualOrientation = orientation
        let direction: CoordinateHemisphere? = try resolveDirection(inResult: match, for: str)

        if let direction = direction {
            switch direction {
            case .south, .west:
                if degrees > 0 { degrees.negate() }
            case .north, .east:
                if degrees < 0 { degrees.negate() }
            }

            if orientation != .unspecified {
                // Expected orientation does not match parsed direction
                guard orientation == direction.orientation else { throw ParsingError.invalidDirection }
            }

            actualOrientation = direction.orientation
        }

        if [DegreesFormat.degreesDecimalMinutes, DegreesFormat.degreesMinutesSeconds].contains(degreesFormat) {
            let minutes = try self.minutes(inResult: match, for: str)
            let minutesAsDegrees = (minutes / 60)
            degrees += degrees < 0 ? -minutesAsDegrees : minutesAsDegrees
        }

        if coordinateFormat == .degreesMinutesSeconds {
            let seconds = try self.seconds(inResult: match, for: str)
            let secondsAsDegrees = (seconds / 3600)
            degrees += degrees < 0 ? -secondsAsDegrees : secondsAsDegrees
        }

        guard actualOrientation.range.contains(degrees) else { throw ParsingError.invalidRangeDegrees }

        return NSNumber(value: degrees.roundedTo(places: Int(maximumDegreesFractionDigits)))
    }

    // MARK: - Formatters

    private lazy var degreesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumDegreesFractionDigits
        formatter.maximumFractionDigits = maximumDegreesFractionDigits
        return formatter
    }()

    private lazy var minutesFormatter: NumberFormatter = {
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
