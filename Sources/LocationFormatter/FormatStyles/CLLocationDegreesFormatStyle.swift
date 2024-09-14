import CoreLocation
import Foundation

public extension CLLocationDegrees {
    
    struct FormatStyle: Codable, Equatable, Hashable {
        
        /// Creates a new FormatStyle.
        /// - Parameters:
        ///   - format: The ``CoordinateFormat`` used to represent a `CLLocationDegrees` value as a string.
        ///   - symbolStyle: The ``SymbolStyle`` used to annotate coordinate components.
        ///   - options: The ``DisplayOptions`` for creating a textutal representation of a `CLLocationDegrees` value.
        ///   - fractionLimits: A range from the minimum to the maximum number of digits to use when formatting the fraction part of the `CLLocationDegrees` value.
        ///   - orientation: Defines whether the `CLLocationDegrees` value represents latitude or longitude.
        public init(
            format: CoordinateFormat = .decimalDegrees,
            symbolStyle: SymbolStyle = .simple,
            options: DisplayOptions = [.suffix],
            fractionLimits: ClosedRange<Int> = 1...5,
            type: CoordinateType? = nil
        ) {
            self.degreesFormat = DegreesFormat(coordinateFormat: format) ?? .decimalDegrees
            self.symbolStyle = symbolStyle
            self.options = options
            self.fractionLimits = fractionLimits
            self.type = type
        }
        
        // MARK: Customization Method Chaining
        
        public func coordinateFormat(_ format: CoordinateFormat) -> Self {
            .init(format: format)
        }
        
        public func symbolStyle(_ style: SymbolStyle) -> Self {
            .init(symbolStyle: style)
        }
        
        public func options(_ options: DisplayOptions) -> Self {
            .init(options: options)
        }
        
        public func fractionLimits(_ limits: ClosedRange<Int>) -> Self {
            .init(fractionLimits: limits)
        }
        
        public func type(_ type: CoordinateType) -> Self {
            .init(type: type)
        }
        
        // MARK: - Private
        
        private let type: CoordinateType?
        private let degreesFormat: DegreesFormat
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
        private let fractionLimits: ClosedRange<Int>
        
        private var isCompact: Bool {
            // cant be compact if not using symbols
            options.contains(.compact) && symbolStyle != .none
        }
    }
}


extension CLLocationDegrees.FormatStyle: Foundation.FormatStyle {

    public func format(_ value: CLLocationDegrees) -> String {
        var coordinateComponent: CoordinateComponent?
        
        if let type {
            do {
                coordinateComponent = try CoordinateComponent(value, type: type)
            } catch {
                return ""
            }
        }
        
        var degrees = coordinateComponent?.value ?? value
        let hemisphere = coordinateComponent?.hemisphere
                
        if options.contains(.suffix), hemisphere != nil { degrees = abs(degrees) }
        
        let minutes = (abs(degrees) * 60.0).truncatingRemainder(dividingBy: 60.0)
        let seconds = (abs(degrees) * 3600.0).truncatingRemainder(dividingBy: 60.0)
        
        var components: [String] = []
        
        switch degreesFormat {
        case .decimalDegrees:
            let deg = degrees.formatted(
                .number.decimalSeparator(strategy: .always)
                .precision(
                    .fractionLength(fractionLimits)
                )
            )
            
            components = ["\(deg)\(symbolStyle.degrees)"]

        case .degreesDecimalMinutes:
            let deg = Int(degrees >= 0 ? floor(degrees) : ceil(degrees))
            
            let min = minutes.formatted(
                .number
                .decimalSeparator(strategy: .always)
                .precision(.integerAndFractionLength(integer: 2, fraction: 3))
            )
            
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
        
        if options.contains(.suffix), let suffix = hemisphere?.rawValue {
            components.append(suffix)
        }
        
        return components.joined(separator: isCompact ? "" : " ")
    }
}

public extension CLLocationDegrees.FormatStyle {
    
    struct ParseStrategy: Foundation.ParseStrategy {
        
        public init(
            format: CoordinateFormat = .decimalDegrees,
            orientation: CoordinateOrientation = .unspecified,
            maximumDegreesFractionDigits: Int = 5,
            options: ParsingOptions = [.caseInsensitive]
        ) {
            self.degreesFormat = DegreesFormat(coordinateFormat: format) ?? .decimalDegrees
            self.orientation = .unspecified
            self.maximumDegreesFractionDigits = maximumDegreesFractionDigits
            self.options = options
        }
        
        
        public func parse(_ value: String) throws -> CLLocationDegrees {
            let str = value.desymbolized()
            
            var options: NSRegularExpression.Options = [.useUnicodeWordBoundaries]
            if options.contains(.caseInsensitive) { options.insert(.caseInsensitive) }
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
            
            return degrees.roundedTo(places: Int(maximumDegreesFractionDigits))
        }
        
        /// The coordinate format used by the receiver.
        var coordinateFormat: CoordinateFormat {
            degreesFormat.coordinateFormat
        }
        
        // MARK: - Private
        
        let degreesFormat: DegreesFormat
        let orientation: CoordinateOrientation
        let options: ParsingOptions
        let maximumDegreesFractionDigits: Int
        
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
        
        private func doubleValue(forName name: String,
                         inResult result: NSTextCheckingResult,
                         for string: String) throws -> Double {
            let val = try value(forName: name, inResult: result, for: string)
            guard let double = Double(val) else { throw ParsingError.notFound(name: name) }
            return double
        }
        
        private func value(forName name: String,
                   inResult result: NSTextCheckingResult,
                   for string: String) throws -> String {
            let matchedRange = result.range(withName: name)
            guard matchedRange.location != NSNotFound, let range = Range(matchedRange, in: string) else {
                throw ParsingError.notFound(name: name)
            }
            return String(string[range])
        }
    }
}


// MARK: ParseableFormatStyle conformance on CLLocationDegrees.FormatStyle

extension CLLocationDegrees.FormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationDegrees.FormatStyle.ParseStrategy {
        .init()
    }
}

// MARK: Convenience members on CLLocationDegrees to simplify access to the ParseStrategy

public extension CLLocationDegrees {

//    init(_ string: String) throws {
//        self = try CLLocationDegrees.FormatStyle().parseStrategy.parse(string)
//    }

    init<T, Value>(_ value: Value, standard: T) throws where T: ParseStrategy, Value: StringProtocol, T.ParseInput == String, T.ParseOutput == CLLocationDegrees {
        self = try standard.parse(value.description)
    }
}

