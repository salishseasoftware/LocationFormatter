import CoreLocation

public extension CLLocationCoordinate2D {
    struct DegreesMinutesSecondsFormatStyle: Codable, Equatable, Hashable {
        public init(
            format: CoordinateFormat = .decimalDegrees,
            symbolStyle: SymbolStyle = .simple,
            options: DisplayOptions = [.suffix]
        ) {
            self.format = format
            self.symbolStyle = symbolStyle
            self.options = options
        }
        
        // MARK:  Private
        
        private let format: CoordinateFormat
        private let symbolStyle: SymbolStyle
        private let options: DisplayOptions
    }
}

extension CLLocationCoordinate2D.DegreesMinutesSecondsFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocationCoordinate2D
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocationCoordinate2D) -> String {
        guard CLLocationCoordinate2DIsValid(value) else { return "" }
        
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
    }
}
    
public extension CLLocationCoordinate2D.DegreesMinutesSecondsFormatStyle {
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
            
            let latitude = try CLLocationDegrees.DegreesMinutesSecondsFormatStyle.ParseStrategy(
                orientation: .latitude,
                options: options
            ).parse(components[0])
            
            let longitude = try CLLocationDegrees.DegreesMinutesSecondsFormatStyle.ParseStrategy(
                orientation: .longitude,
                options: options
            ).parse(components[1])
            
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

extension CLLocationCoordinate2D.DegreesMinutesSecondsFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationCoordinate2D.DecimalDegreesFormatStyle.ParseStrategy {
        .init()
    }
}




