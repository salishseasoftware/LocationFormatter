import CoreLocation
import Foundation
import GeoURI
import UTMConversion

public extension CLLocationCoordinate2D {
    
    struct FormatStyle: Codable, Equatable, Hashable {
        
        /// Creates a new FormatStyle.
        /// - Parameters:
        ///   - format: The ``CoordinateFormat`` used to represent a `CLLocationDegrees` value as a string.
        ///   - symbolStyle: The ``SymbolStyle`` used to annotate coordinate components.
        ///   - options: The ``DisplayOptions`` for creating a textutal representation of a `CLLocationDegrees` value.
        ///   - fractionLimits: A range from the minimum to the maximum number of digits to use when formatting the fraction part of the `CLLocationDegrees` value.
        public init(
            format: CoordinateFormat = .decimalDegrees,
            symbolStyle: SymbolStyle = .simple,
            options: DisplayOptions = [.suffix],
            fractionLimits: ClosedRange<Int> = 1...5
        ) {
            self.format = format
            self.symbolStyle = symbolStyle
            self.options = options
            self.fractionLimits = fractionLimits
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
        
        // MARK: - Private
        
        private let format: CoordinateFormat
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
        private let fractionLimits: ClosedRange<Int>
    }
}
        
extension CLLocationCoordinate2D.FormatStyle: Foundation.FormatStyle {
    
    public func format(_ value: CLLocationCoordinate2D) -> String {
        
        guard CLLocationCoordinate2DIsValid(value) else { return "" }
        
        switch format {
        case .decimalDegrees:
            let lat = value.latitude.formatted(
                CLLocationDegrees.DecimalDegreesFormatStyle(
                    symbolStyle: symbolStyle,
                    options: options,
                    fractionLimits: fractionLimits,
                    type: .latitude
                )
            )
            
            let lon = value.longitude.formatted(
                CLLocationDegrees.FormatStyle(
                    format: format,
                    symbolStyle: symbolStyle,
                    options: options,
                    fractionLimits: fractionLimits,
                    type: .longitude
                )
            )
            
            return "\(lat), \(lon)"
            
        case .degreesDecimalMinutes:
            let lat = value.latitude.formatted(
                CLLocationDegrees.DegreesDecimalMinutesFormatStyle(
                    symbolStyle: symbolStyle,
                    options: options,
                    type: .latitude
                )
            )
            
            let lon = value.longitude.formatted(
                CLLocationDegrees.DegreesDecimalMinutesFormatStyle(
                    symbolStyle: symbolStyle,
                    options: options,
                    type: .longitude
                )
            )
            
            return "\(lat), \(lon)"
            
        case .degreesMinutesSeconds:
            let lat = value.latitude.formatted(
                CLLocationDegrees.DegreesMinutesSecondsFormatStyle(
                    symbolStyle: symbolStyle,
                    options: options,
                    type: .latitude
                )
            )
            
            let lon = value.longitude.formatted(
                CLLocationDegrees.DegreesMinutesSecondsFormatStyle(
                    symbolStyle: symbolStyle,
                    options: options,
                    type: .longitude
                )
            )
            
            return "\(lat), \(lon)"
            
        case .utm:
            let utm = try? value.utmCoordinate()
            return utm?.formatted() ?? ""
            
        case .geoURI:
            let geoURI = try? GeoURI(coordinate: value)
            return geoURI?.formatted() ?? ""
        }
    }
    
    private func degreeString(from coordinate: CLLocationCoordinate2D) -> String {
        let lat = coordinate.latitude.formatted(
            CLLocationDegrees.FormatStyle(
                format: format,
                symbolStyle: symbolStyle,
                options: options,
                fractionLimits: fractionLimits,
                type: .latitude
            )
        )
        
        let lon = coordinate.longitude.formatted(
            CLLocationDegrees.FormatStyle(
                format: format,
                symbolStyle: symbolStyle,
                options: options,
                fractionLimits: fractionLimits,
                type: .longitude
            )
        )
        
        return "\(lat), \(lon)"
    }
}
