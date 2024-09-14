import CoreLocation
import Testing
@testable import LocationFormatter


struct CLLocationCoordinate2DTests {
    @Test("Dateline coordinate normalization") func datelineNormalization() {
        var actual: CLLocationCoordinate2D = .pointNemo.normalized()
        #expect(actual.latitude == -48.876667)
        #expect(actual.longitude == -123.393333)
        
        actual = CLLocationCoordinate2D(latitude: -48.876667, longitude: 180).normalized()
        #expect(actual.latitude == -48.876667)
        #expect(actual.longitude == 180.0)
        
        actual = CLLocationCoordinate2D(latitude: -48.876667, longitude: -180).normalized()
        #expect(actual.latitude == -48.876667)
        #expect(actual.longitude == 180.0)
    }
    
    @Test("Polar longitude  coordinate normalization") func polarLongitude() {
        var actual = CLLocationCoordinate2D.pointNemo.normalized()
        #expect(actual.latitude == -48.876667)
        #expect(actual.longitude == -123.393333)
        
        actual = CLLocationCoordinate2D(latitude: 90, longitude: -123.393333).normalized()
        #expect(actual.latitude == 90.0)
        #expect(actual.longitude == .zero)
        
        actual = CLLocationCoordinate2D(latitude: -90, longitude: -123.393333).normalized()
        #expect(actual.latitude == -90.0)
        #expect(actual.longitude == .zero)
    }
}
