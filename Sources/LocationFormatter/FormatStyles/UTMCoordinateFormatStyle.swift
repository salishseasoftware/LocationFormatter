import Foundation
import UTMConversion
import CoreLocation
import RegexBuilder

public extension UTMCoordinate {
    struct FormatStyle {
        
        public init(options: DisplayOptions = [.suffix]) {
            if options.contains(.suffix) {
                eastingSuffix = options.contains(.compact) ?  "E" : " E"
                northingSuffix = options.contains(.compact) ?  "N" : " N"
            } else {
                eastingSuffix = ""
                northingSuffix = ""
            }
        }
        
        public func options(_ options: DisplayOptions) -> Self {
            .init(options: options)
        }
        
        private static let numberStyle = FloatingPointFormatStyle<Double>()
            .rounded()
            .precision(.integerLength(6...7))
            .precision(.fractionLength(0))
            .sign(strategy: .never)
            .grouping(.never)
        
        private let eastingSuffix: String
        private let northingSuffix: String
    }
}


extension UTMCoordinate.FormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = UTMCoordinate
    public typealias FormatOutput = String
    
    public func format(_ value: UTMCoordinate) -> String {
        let band = value.coordinate().latitudeBand?.rawValue ?? ""
        let easting = value.easting.formatted(Self.numberStyle).padding(toLength: 6, withPad: "0", startingAt: 0)
        let northing = value.northing.formatted(Self.numberStyle).padding(toLength: 7, withPad: "0", startingAt: 0)
        
        return "\(value.zone)\(band) \(easting)m\(eastingSuffix) \(northing)m\(northingSuffix)"
    }
}


extension FormatStyle where Self == UTMCoordinate.FormatStyle {
    static var compact: UTMCoordinate.FormatStyle { UTMCoordinate.FormatStyle(options: [.suffix, .compact]) }
    static var short:  UTMCoordinate.FormatStyle { UTMCoordinate.FormatStyle(options: [.compact]) }
}

public extension UTMCoordinate {
    /// Converts `self` to its textual representation.
    /// - Returns: String
    func formatted() -> String {
        Self.FormatStyle().format(self)
    }
    
    /// Converts `self` to another representation.
    /// - Parameter style: The format for formatting `self`
    /// - Returns: A representations of `self` using the given `style`. The type of the return is determined by the FormatStyle.FormatOutput
    func formatted<F: Foundation.FormatStyle>(_ style: F) -> F.FormatOutput where F.FormatInput == UTMCoordinate {
        style.format(self)
    }
}


// MARK: - Parsing

public extension UTMCoordinate.FormatStyle {
    
    struct ParseStrategy: Foundation.ParseStrategy {
        public typealias ParseInput = String
        public typealias ParseOutput = UTMCoordinate
        
        public func parse(_ value: String) throws -> UTMCoordinate {
            let zoneRef = Reference(UTMGridZone.self)
            let bandRef = Reference(UTMLatitudeBand.self)
            let eastingRef = Reference(Double.self)
            let northingRef = Reference(Double.self)

            let eastingOrNorthingRegex = Repeat(6...) {
                One(.digit)
            }

            let zoneRegex = ChoiceOf {
                Regex {
                  Optionally {
                    "0"
                  }
                  ("1"..."9")
                }
                Regex {
                  "1"
                  ("0"..."9")
                }
                Regex {
                  "2"
                  ("0"..."9")
                }
                Regex {
                  "3"
                  ("0"..."9")
                }
                Regex {
                  "4"
                  ("0"..."9")
                }
                Regex {
                  "5"
                  ("0"..."9")
                }
                "60"
            }

            let bandRegex = One(.anyOf("CDEFGHJKLMNPQRSTUVWX"))
            
            let utmRegex = Regex {
                Anchor.startOfLine
                TryCapture(zoneRegex, as: zoneRef) {
                    guard let zone = UTMGridZone($0) else {
                        throw ParsingError.invalidZone
                    }
                    return zone
                }
                TryCapture(bandRegex, as: bandRef) {
                    guard let band = UTMLatitudeBand(rawValue: String($0)) else {
                        throw ParsingError.invalidLatitudeBand
                    }
                    return band
                }
                
                OneOrMore(.horizontalWhitespace)
                TryCapture(eastingOrNorthingRegex, as: eastingRef) {
                    guard (6...7).contains(String($0).count), let value = Double($0) else {
                        throw ParsingError.noMatch
                    }
                    return value
                }
                "m"
                Optionally(.horizontalWhitespace)
                Optionally { "E" }
                OneOrMore(.horizontalWhitespace)
                TryCapture(eastingOrNorthingRegex, as: northingRef) {
                    guard (6...7).contains(String($0).count), let value = Double($0) else {
                        throw ParsingError.noMatch
                    }
                    return value
                }
                "m"
                Optionally(.horizontalWhitespace)
                Optionally { "N" }
                Anchor.endOfLine
            }
            .anchorsMatchLineEndings()
            
            guard let match = value.firstMatch(of: utmRegex) else {
                throw ParsingError.noMatch
            }
                                    
            return UTMCoordinate(
                northing: match[northingRef],
                easting: match[eastingRef],
                zone: match[zoneRef],
                hemisphere: match[bandRef].hemisphere
            )
        }
    }
}


extension UTMCoordinate.FormatStyle: ParseableFormatStyle {
    public var parseStrategy: UTMCoordinate.FormatStyle.ParseStrategy {
        .init()
    }
}
