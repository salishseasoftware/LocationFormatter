import Foundation
import CoreLocation
import GeoURI

public extension CLLocationCoordinate2D {
    struct GeoURIFormatStyle: Codable, Equatable, Hashable {
        
        public init(includeCRS: Bool = true) {
            self.includeCRS = includeCRS
        }
        
        private let includeCRS: Bool
    }
}

extension CLLocationCoordinate2D.GeoURIFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocationCoordinate2D
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocationCoordinate2D) -> String {
        guard CLLocationCoordinate2DIsValid(value), let geoURI = try? GeoURI(coordinate: value) else {
            return ""
        }
        return geoURI.formatted(includeCRS: includeCRS)
    }
}

public extension CLLocationCoordinate2D.GeoURIFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocationCoordinate2D
        
        public func parse(_ value: String) throws -> CLLocationCoordinate2D {
            return try GeoURI.FormatStyle()
                .parseStrategy
                .parse(value)
                .coordinate
        }
    }
}

extension CLLocationCoordinate2D.GeoURIFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationCoordinate2D.GeoURIFormatStyle.ParseStrategy {
        .init()
    }
}
