import Foundation
import CoreLocation
import UTMConversion

public extension CLLocation {
    struct UTMCoordinateFormatStyle: Codable, Equatable, Hashable {
        
        public init(options: DisplayOptions = [.suffix]) {
            self.options = options
        }
        
        private let options: DisplayOptions
    }
}

extension CLLocation.UTMCoordinateFormatStyle: Foundation.FormatStyle {
    public typealias FormatInput = CLLocation
    public typealias FormatOutput = String
    
    public func format(_ value: CLLocation) -> String {
        guard let utm = try? value.utmCoordinate() else {
            return ""
        }
        return UTMCoordinate.FormatStyle(options: options).format(utm)
    }
}

public extension CLLocation.UTMCoordinateFormatStyle {
    struct ParseStrategy: Foundation.ParseStrategy {
        public typealias ParseInput = String
        public typealias ParseOutput = CLLocation
        
        public func parse(_ value: String) throws -> CLLocation {
            let utm = try UTMCoordinate.FormatStyle.ParseStrategy().parse(value)
            return utm.location()
        }
    }
}

extension CLLocation.UTMCoordinateFormatStyle: ParseableFormatStyle {
    public var parseStrategy: CLLocation.UTMCoordinateFormatStyle.ParseStrategy {
        .init()
    }
}
