import XCTest
import CoreLocation
@testable import LocationFormatter


public func XCTAssertEqualCoordinates(_ expected: CLLocationCoordinate2D,
                                      _ actual: CLLocationCoordinate2D?,
                                      accuracy: Double? = nil,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    guard let lat = actual?.latitude, let lon = actual?.longitude else {
        XCTAssertNotNil(actual)
        return
    }

    if let accuracy = accuracy {
        XCTAssertEqual(lat, expected.latitude, accuracy: accuracy, file: file, line: line)
        XCTAssertEqual(lon, expected.longitude, accuracy: accuracy, file: file, line: line)
    } else {
        XCTAssertEqual(lat, expected.latitude, file: file, line: line)
        XCTAssertEqual(lon, expected.longitude, file: file, line: line)
    }
}

extension CLLocationCoordinate2D {
    static let portTownsend = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
    static let capeHorn = CLLocationCoordinate2D(latitude: -55.97917, longitude: -67.275)
    static let seychelles = CLLocationCoordinate2D(latitude: -4.67785, longitude: 55.46718)
    static let faroeIslands = CLLocationCoordinate2D(latitude: 62.06323, longitude: -6.87355)
    static let amchitkaIsland = CLLocationCoordinate2D(latitude: 51.37363, longitude: 179.41535)
    static let pointNemo = CLLocationCoordinate2D(latitude: -48.876667, longitude: -123.393333)
}

extension CLLocation {    
    static let mountEverest = CLLocation(
        coordinate: CLLocationCoordinate2D(latitude: 27.988056, longitude: 86.925278),
        altitude: 8848.86,
        horizontalAccuracy: 0,
        verticalAccuracy: 0.21,
        timestamp: Date()
    )
    
    static let challengerDeep = CLLocation(
        coordinate: CLLocationCoordinate2D(latitude: 11.373333, longitude: 142.591667),
        altitude: -10920,
        horizontalAccuracy: 0.0,
        verticalAccuracy: 10.0,
        timestamp: Date()
    )
    
    static let pointNemo = CLLocation(coordinate: .pointNemo)
}
