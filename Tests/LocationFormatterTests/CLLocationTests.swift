import CoreLocation
import XCTest
@testable import LocationFormatter

final class CLLocationTests: XCTestCase {

    func testHorizontalUncertainty() {
        var location = CLLocation(coordinate: .pointNemo)
        XCTAssertNil(location.horizontalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 0,
            horizontalAccuracy: 1.23,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertEqual(1.23, location.horizontalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 0,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertNil(location.horizontalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 0,
            horizontalAccuracy: -1.23,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertNil(location.horizontalUncertainty)
    }
    
    func testVerticalUncertainty() {
        var location = CLLocation(coordinate: .pointNemo)
        XCTAssertNil(location.verticalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 0,
            horizontalAccuracy: 0,
            verticalAccuracy: 1.23,
            timestamp: Date()
        )
        XCTAssertNil(location.verticalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 66.6,
            horizontalAccuracy: 0,
            verticalAccuracy: 1.23,
            timestamp: Date()
        )
        XCTAssertEqual(1.23, location.verticalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 66.6,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertNil(location.verticalUncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 66.6,
            horizontalAccuracy: 0,
            verticalAccuracy: -1.23,
            timestamp: Date()
        )
        XCTAssertNil(location.verticalUncertainty)
    }
    
    func testUncertainty() {
        var location = CLLocation(coordinate: .pointNemo)
        XCTAssertNil(location.uncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 999,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertNil(location.uncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 999,
            horizontalAccuracy: 1.23,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        XCTAssertEqual(1.23, location.uncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 999,
            horizontalAccuracy: 0,
            verticalAccuracy: 4.56,
            timestamp: Date()
        )
        XCTAssertEqual(4.56, location.uncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 0,
            horizontalAccuracy: 0,
            verticalAccuracy: 4.56,
            timestamp: Date()
        )
        XCTAssertNil(location.uncertainty)
        
        location = CLLocation(
            coordinate: .pointNemo,
            altitude: 999,
            horizontalAccuracy: 1.23,
            verticalAccuracy: 4.56,
            timestamp: Date()
        )
        XCTAssertEqual(4.56, location.uncertainty)
    }
}
