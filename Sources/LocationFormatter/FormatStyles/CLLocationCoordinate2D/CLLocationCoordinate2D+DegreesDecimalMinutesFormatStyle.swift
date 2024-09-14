import CoreLocation

public extension CLLocationCoordinate2D {
    struct DegreesDecimalMinutesFormatStyle: Codable, Equatable, Hashable {
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
        
        // MARK: - Private
        
        private let format: CoordinateFormat
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
        private let fractionLimits: ClosedRange<Int>
    }
}

extension CLLocationCoordinate2D.DegreesDecimalMinutesFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocationCoordinate2D
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocationCoordinate2D) -> String {
        guard CLLocationCoordinate2DIsValid(value) else { return "" }
        
        let lat = value.latitude.formatted(
            CLLocationDegrees.DegreesDecimalMinutesFormatStyle(
                symbolStyle: symbolStyle,
                options: options,
                fractionLimits: fractionLimits,
                type: .latitude
            )
        )
        
        let lon = value.longitude.formatted(
            CLLocationDegrees.DegreesDecimalMinutesFormatStyle(
                symbolStyle: symbolStyle,
                options: options,
                fractionLimits: fractionLimits,
                type: .longitude
            )
        )
        
        return "\(lat), \(lon)"
    }
}

public extension CLLocationCoordinate2D.DegreesDecimalMinutesFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        
        public init(
            options: ParsingOptions = [.caseInsensitive]
        ) {
            self.options = options
        }
        
        // MARK: - ParseStrategy
        
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocationCoordinate2D
        
        public func parse(_ value: String) throws -> CLLocationCoordinate2D {
            let components = try LocationFormat.components(from: value)
            
            let latitude = try CLLocationDegrees.DegreesDecimalMinutesFormatStyle.ParseStrategy(
                orientation: .latitude,
                options: options
            ).parse(components[0])
            
            let longitude = try CLLocationDegrees.DegreesDecimalMinutesFormatStyle.ParseStrategy(
                orientation: .longitude,
                options: options
            ).parse(components[0])
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            guard CLLocationCoordinate2DIsValid(coordinate) else {
                throw ParsingError.invalidCoordinate
            }
            
            return coordinate
        }
        
        // MARK: - Private
        
        let options: ParsingOptions
    }
}

extension CLLocationCoordinate2D.DegreesDecimalMinutesFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationCoordinate2D.DecimalDegreesFormatStyle.ParseStrategy {
        .init()
    }
}

    
