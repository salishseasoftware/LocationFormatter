import Foundation
import CoreLocation
import UTMConversion

public extension CLLocationCoordinate2D {
    struct UTMCoordinateFormatStyle: Codable, Equatable, Hashable {
        
        public init(options: DisplayOptions = [.suffix]) {
            self.options = options
        }
        
        private let options: DisplayOptions
    }
}

extension CLLocationCoordinate2D.UTMCoordinateFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocationCoordinate2D
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocationCoordinate2D) -> String {
        guard CLLocationCoordinate2DIsValid(value), let utm = try? value.utmCoordinate() else {
            return ""
        }
        return UTMCoordinate.FormatStyle(options: options).format(utm)
    }
}

public extension CLLocationCoordinate2D.UTMCoordinateFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocationCoordinate2D
        
        public func parse(_ value: String) throws -> CLLocationCoordinate2D {
            let utm = try UTMCoordinate.FormatStyle.ParseStrategy().parse(value)
            return utm.coordinate()
        }
    }
}

extension CLLocationCoordinate2D.UTMCoordinateFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocationCoordinate2D.UTMCoordinateFormatStyle.ParseStrategy {
        .init()
    }
}
