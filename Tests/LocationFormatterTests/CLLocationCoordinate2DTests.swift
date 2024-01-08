import CoreLocation
import XCTest
@testable import LocationFormatter


final class CLLocationCoordinate2DTests: XCTestCase {

    func testDatelineNormalization() {
        var coordinate: CLLocationCoordinate2D = .pointNemo
        var normalized = coordinate.normalized()
        XCTAssertEqual(-48.876667, normalized.latitude)
        XCTAssertEqual(-123.393333, normalized.longitude)
        
        coordinate = CLLocationCoordinate2D(latitude: -48.876667, longitude: 180)
        normalized = coordinate.normalized()
        XCTAssertEqual(-48.876667, normalized.latitude)
        XCTAssertEqual(180.0, normalized.longitude)
        
        coordinate = CLLocationCoordinate2D(latitude: -48.876667, longitude: -180)
        normalized = coordinate.normalized()
        XCTAssertEqual(-48.876667, normalized.latitude)
        XCTAssertEqual(180.0, normalized.longitude)
    }
    
    func testPolarLongitude() {
        var actual = CLLocationCoordinate2D.pointNemo.normalized()
        XCTAssertEqual(-48.876667, actual.latitude)
        XCTAssertEqual(-123.393333, actual.longitude)
        
        actual = CLLocationCoordinate2D(latitude: 90, longitude: -123.393333).normalized()
        XCTAssertEqual(90.0, actual.latitude)
        XCTAssertEqual(.zero, actual.longitude)
        
        actual = CLLocationCoordinate2D(latitude: -90, longitude: -123.393333).normalized()
        XCTAssertEqual(-90.0, actual.latitude)
        XCTAssertEqual(.zero, actual.longitude)
    }
}
