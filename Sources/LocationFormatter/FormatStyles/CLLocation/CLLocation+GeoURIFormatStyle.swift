import Foundation
import CoreLocation
import GeoURI

public extension CLLocation {
    struct GeoURIFormatStyle: Codable, Equatable, Hashable {
        
        public init(includeCRS: Bool = true) {
            self.includeCRS = includeCRS
        }
        
        private let includeCRS: Bool
    }
}

extension CLLocation.GeoURIFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocation
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocation) -> String {
        guard CLLocationCoordinate2DIsValid(value.coordinate), let geoURI = try? GeoURI(location: value) else {
            return ""
        }
        return geoURI.formatted(includeCRS: includeCRS)
    }
}

public extension CLLocation.GeoURIFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocation
        
        public func parse(_ value: String) throws -> CLLocation {
            return try GeoURI.FormatStyle()
                .parseStrategy
                .parse(value)
                .location
        }
    }
}

extension CLLocation.GeoURIFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocation.GeoURIFormatStyle.ParseStrategy {
        .init()
    }
}
