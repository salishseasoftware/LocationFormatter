import CoreLocation
import Foundation
import RegexBuilder


public extension CLLocationDegrees {
    
    struct DecimalDegreesFormatStyle: Codable, Equatable, Hashable {
        
        public init(
            symbolStyle: SymbolStyle = .simple,
            options: DisplayOptions = [.suffix],
            fractionLimits: ClosedRange<Int> = 1...5,
            type: CoordinateType? = nil
        ) {
            self.type = type
            self.symbolStyle = symbolStyle
            self.options = options
            self.fractionLimits = fractionLimits
        }
        
        // MARK: Customization Method Chaining
        
        public func symbolStyle(_ style: SymbolStyle) -> DecimalDegreesFormatStyle {
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
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
        private let fractionLimits: ClosedRange<Int>
        
        private var isCompact: Bool {
            // cant be compact if not using symbols
            options.contains(.compact) && symbolStyle != .none
        }
    }
}

extension CLLocationDegrees.DecimalDegreesFormatStyle: Foundation.FormatStyle {
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
        
        var components: [String] = []
        
        let deg = degrees.formatted(
            .number.decimalSeparator(strategy: .always)
            .precision(
                .fractionLength(fractionLimits)
            )
        )
        
        components = ["\(deg)\(symbolStyle.degrees)"]
        
        if options.contains(.suffix), let suffix = hemisphere?.rawValue {
            components.append(suffix)
        }
        
        return components.joined(separator: isCompact ? "" : " ")
    }
}

public extension CLLocationDegrees.DecimalDegreesFormatStyle {
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
            let degreesRef = Reference(CLLocationDegrees.self)
            let suffixRef = Reference(Substring.self)
                        
            let degreesRegex = Regex {
                Optionally {
                    "-"
                }
                Repeat(1...3) {
                    One(.digit)
                }
                "."
                OneOrMore(.digit)
            }
            
            let regex = Regex {
                Anchor.startOfLine
                Capture(LocationFormat.cardinalDirectionRegex, as: prefixRef)
                Optionally(.horizontalWhitespace)
                TryCapture(degreesRegex, as: degreesRef) {
                    guard let degrees = CLLocationDegrees($0), (-180...180).contains(degrees) else {
                        throw ParsingError.invalidRangeDegrees
                    }
                    return degrees
                }
                Optionally(.horizontalWhitespace)
                Capture(LocationFormat.cardinalDirectionRegex, as: suffixRef)
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
                minutes: nil,
                seconds: nil,
                orientation: orientation,
                inHemisphere: hemisphere
            )
        }
        
        // MARK: - Private
        
        let orientation: CoordinateOrientation
        let options: ParsingOptions
    }
}
    
extension CLLocationDegrees.DecimalDegreesFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationDegrees.DecimalDegreesFormatStyle.ParseStrategy {
        .init()
    }
}
