import CoreLocation
import Testing
@testable import LocationFormatter

@Suite struct CLLocationTests {
    @Suite struct HorizontalUncertainty {
        @Test func positiveValue() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 0,
                horizontalAccuracy: 0.1,
                verticalAccuracy: 0,
                timestamp: Date()
            )
            
            #expect(location.horizontalUncertainty == 0.1)
        }
        
        @Test func negativeValue() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 0,
                horizontalAccuracy: -0.1,
                verticalAccuracy: 0,
                timestamp: Date()
            )
            
            #expect(location.horizontalUncertainty == nil)
        }
        
        @Test func zeroValue() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 0,
                horizontalAccuracy: 0,
                verticalAccuracy: 0,
                timestamp: Date()
            )
            
            #expect(location.horizontalUncertainty == nil)
        }
    }
    
    @Suite struct VerticalUncertainty {
        @Test(arguments:[1.23, -1.23, 0.0])
        func zeroValue(altitude: Double) {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: altitude,
                horizontalAccuracy: 0,
                verticalAccuracy: .zero,
                timestamp: Date()
            )
            
            #expect(location.verticalUncertainty == nil)
        }
        
        @Test func nonZeroValue() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 1.23,
                horizontalAccuracy: 0,
                verticalAccuracy: 1.0,
                timestamp: Date()
            )
            
            #expect(location.verticalUncertainty == 1.0)
        }
        
        @Test(arguments:
                [1.23, -1.23, 0.0]
        ) func zeroAltitude(verticalAccuracy: Double) {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 0,
                horizontalAccuracy: 0,
                verticalAccuracy: verticalAccuracy,
                timestamp: Date()
            )
            
            #expect(location.verticalUncertainty == nil)
        }
    }
    
    @Suite struct Uncertainty {
        @Test func zeroHorizontalAndVerticalAccuracy() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 10.0,
                horizontalAccuracy: .zero,
                verticalAccuracy: .zero,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == nil)
        }
        
        @Test func zeroHorizontalAccuracy() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 10.0,
                horizontalAccuracy: .zero,
                verticalAccuracy: 1.0,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == 1.0)
        }
        
        @Test func zeroHVerticalAccuracy() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 10.0,
                horizontalAccuracy: 1.0,
                verticalAccuracy: .zero,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == 1.0)
        }
        
        @Test func greaterHorizontalAccuracy() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 10.0,
                horizontalAccuracy: 1.2,
                verticalAccuracy: 1.1,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == location.horizontalAccuracy)
        }
        
        @Test func greaterVerticalAccuracy() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: 10.0,
                horizontalAccuracy: 1.1,
                verticalAccuracy: 1.2,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == location.verticalAccuracy)
        }
        
        @Test func greaterVerticalAccuracyZeroAltitude() {
            let location = CLLocation(
                coordinate: .pointNemo,
                altitude: .zero,
                horizontalAccuracy: 1.1,
                verticalAccuracy: 1.2,
                timestamp: Date()
            )
            
            #expect(location.uncertainty == location.horizontalAccuracy)
        }
    }
}
    
