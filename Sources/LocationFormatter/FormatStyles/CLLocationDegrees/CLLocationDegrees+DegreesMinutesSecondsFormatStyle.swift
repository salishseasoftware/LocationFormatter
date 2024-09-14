import CoreLocation
import Foundation
import RegexBuilder


public extension CLLocationDegrees {
    
    struct DegreesMinutesSecondsFormatStyle: Codable, Equatable, Hashable {
        
        public init(
            symbolStyle: SymbolStyle = .simple,
            options: DisplayOptions = [.suffix],
            type: CoordinateType? = nil
        ) {
            self.type = type
            self.symbolStyle = symbolStyle
            self.options = options
        }
        
        // MARK: Customization Method Chaining
        
        public func symbolStyle(_ style: SymbolStyle) -> Self {
            .init(symbolStyle: style)
        }
        
        public func options(_ options: DisplayOptions) -> Self {
            .init(options: options)
        }
        
        public func type(_ type: CoordinateType) -> Self {
            .init(type: type)
        }
        
        // MARK: - Private
        
        private let type: CoordinateType?
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
        
        private var isCompact: Bool {
            // cant be compact if not using symbols
            options.contains(.compact) && symbolStyle != .none
        }
    }
}

extension CLLocationDegrees.DegreesMinutesSecondsFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocationDegrees
    public typealias FormatOutput = String
    
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
        
        let deg = Int(degrees >= 0 ? floor(degrees) : ceil(degrees))
        let min = Int(floor(minutes))
        let sec = Int(round(seconds))
        
        components = [
            "\(deg)\(symbolStyle.degrees)",
            "\(min)\(symbolStyle.minutes)",
            "\(sec)\(symbolStyle.seconds)"
        ]
        
        if options.contains(.suffix), let hemisphere {
            components.append("\(hemisphere)")
        }
        
        return components.joined(separator: isCompact ? "" : " ")
    }
}

public extension CLLocationDegrees.DegreesMinutesSecondsFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        
        public init(
            orientation: CoordinateOrientation = .unspecified,
            options: ParsingOptions = [.caseInsensitive]
        ) {
            self.orientation = .unspecified
            self.options = options
        }
        
        // MARK: - ParseStrategy
        
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocationDegrees
        
        public func parse(_ value: String) throws -> CLLocationDegrees {
            let prefixRef = Reference(Substring.self)
            let degreesRef = Reference(Double.self)
            let minutesRef = Reference(Double.self)
            let secondsRef = Reference(Double.self)
            let suffixRef = Reference(Substring.self)
                        
            let degreesRegex = Regex {
                Optionally {
                    "-"
                }
                Repeat(1...3) {
                    One(.digit)
                }
            }
            
            let minutesRegex = Repeat(1...2) {
                  One(.digit)
            }
            
            let secondsRegex = Regex {
                Repeat(1...2) {
                    One(.digit)
                }
                Optionally {
                    "."
                }
                ZeroOrMore(.digit)
            }
            
            let regex = Regex {
                Anchor.startOfLine
                Capture(LocationFormat.cardinalDirectionRegex, as: prefixRef)
                Optionally(.horizontalWhitespace)
                TryCapture(degreesRegex, as: degreesRef) {
                    guard let degrees = Double($0), (-180...180).contains(degrees) else {
                        throw ParsingError.invalidRangeDegrees
                    }
                    return degrees
                }
                One(.horizontalWhitespace)
                TryCapture(minutesRegex, as: minutesRef) {
                    guard let minutes = Double($0), (0.0..<60.0).contains(minutes) else {
                        throw ParsingError.invalidRangeMinutes
                    }
                    return minutes
                }
                One(.horizontalWhitespace)
                TryCapture(secondsRegex, as: secondsRef) {
                    guard let seconds = Double($0), (0.0..<60.0).contains(seconds) else {
                        throw ParsingError.invalidRangeMinutes
                    }
                    return seconds
                }
                Optionally(.horizontalWhitespace)
                Capture(LocationFormat.cardinalDirectionRegex, as: suffixRef)
                Optionally(.anyOf("NSEW"))
                Anchor.endOfLine
            }
            .anchorsMatchLineEndings()
            
            guard let match = value.desymbolized().firstMatch(of: regex) else {
                throw ParsingError.noMatch
            }
            
            let hemisphere: CoordinateHemisphere? = try LocationFormat.resolveDirection(
                prefix: String(match[prefixRef]),
                suffix: String(match[suffixRef])
            )
            
            return try LocationFormat.normalize(
                degrees: match[degreesRef],
                minutes: match[minutesRef],
                seconds: match[secondsRef],
                orientation: orientation,
                inHemisphere: hemisphere
            )
        }
        
        // MARK: - Private
        
        let orientation: CoordinateOrientation
        let options: ParsingOptions
    }
}


extension CLLocationDegrees.DegreesMinutesSecondsFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationDegrees.DegreesMinutesSecondsFormatStyle.ParseStrategy {
        .init()
    }
}
