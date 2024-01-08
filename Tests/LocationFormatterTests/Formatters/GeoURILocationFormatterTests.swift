import CoreLocation
@testable import LocationFormatter
import XCTest

final class GeoURILocationFormatterTests: XCTestCase {
    
    private var formatter: GeoURILocationFormatter!
    
    override func setUpWithError() throws {
        formatter = GeoURILocationFormatter()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        formatter = nil
        try super.tearDownWithError()
    }
    
    // MARK: - String Generation

    func testStringFromLocation() {
        XCTAssertEqual("geo:27.988056,86.925278,8848.86;u=0.21", formatter.string(fromLocation: .mountEverest))
        XCTAssertEqual("geo:11.373333,142.591667,-10920;u=10", formatter.string(fromLocation: .challengerDeep))
        XCTAssertEqual("geo:-48.876667,-123.393333", formatter.string(fromLocation: .pointNemo))
    }
    
    func testIncludeCRS() {
        formatter.options.insert(.includeCRS)
        
        XCTAssertEqual("geo:27.988056,86.925278,8848.86;crs=wgs84;u=0.21", formatter.string(fromLocation: .mountEverest))
        XCTAssertEqual("geo:11.373333,142.591667,-10920;crs=wgs84;u=10", formatter.string(fromLocation: .challengerDeep))
        XCTAssertEqual("geo:-48.876667,-123.393333;crs=wgs84", formatter.string(fromLocation: .pointNemo))
        
        XCTAssertEqual("geo:48.11638,-122.77527;crs=wgs84", formatter.string(fromCoordinate: .portTownsend))
        XCTAssertEqual("geo:-55.97917,-67.275;crs=wgs84", formatter.string(fromCoordinate: .capeHorn))
        XCTAssertEqual("geo:-4.67785,55.46718;crs=wgs84", formatter.string(fromCoordinate: .seychelles))
        XCTAssertEqual("geo:62.06323,-6.87355;crs=wgs84", formatter.string(fromCoordinate: .faroeIslands))
        XCTAssertEqual("geo:51.37363,179.41535;crs=wgs84", formatter.string(fromCoordinate: .amchitkaIsland))
    }
    
    func testStringFromCoordinate() {
        XCTAssertEqual("geo:48.11638,-122.77527", formatter.string(fromCoordinate: .portTownsend))
        XCTAssertEqual("geo:-55.97917,-67.275", formatter.string(fromCoordinate: .capeHorn))
        XCTAssertEqual("geo:-4.67785,55.46718", formatter.string(fromCoordinate: .seychelles))
        XCTAssertEqual("geo:62.06323,-6.87355", formatter.string(fromCoordinate: .faroeIslands))
        XCTAssertEqual("geo:51.37363,179.41535", formatter.string(fromCoordinate: .amchitkaIsland))
    }
    
    
    
    // MARK: - String Parsing
    
    func testLocationFromString() throws {
        var actual = try formatter.location(from: "geo:27.988056,86.925278,8848.86;u=0.21")
        XCTAssertEqual(27.988056, actual.coordinate.latitude)
        XCTAssertEqual(86.925278, actual.coordinate.longitude)
        XCTAssertEqual(8_848.86, actual.altitude)
        XCTAssertEqual(0.21, actual.horizontalAccuracy)
        XCTAssertEqual(0.21, actual.verticalAccuracy)
        
        actual = try formatter.location(from: "geo:11.373333,142.591667,-10920;crs=wgs84;u=10")
        XCTAssertEqual(11.373333, actual.coordinate.latitude)
        XCTAssertEqual(142.591667, actual.coordinate.longitude)
        XCTAssertEqual(-10_920, actual.altitude)
        XCTAssertEqual(10.0, actual.horizontalAccuracy)
        XCTAssertEqual(10.0, actual.verticalAccuracy)
        
        actual = try formatter.location(from: "geo:-48.876667,-123.393333;crs=wgs84")
        XCTAssertEqual(-48.876667, actual.coordinate.latitude)
        XCTAssertEqual(-123.393333, actual.coordinate.longitude)
        XCTAssertEqual(.zero, actual.altitude)
        XCTAssertEqual(.zero, actual.horizontalAccuracy)
        XCTAssertEqual(.zero, actual.verticalAccuracy)
    }
    
    // MARK: Scheme
    
    func testScheme() throws {
        // string should begin with the 'geo:' scheme
        var geoURI = "48.11638,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo48.11638,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo://48.11638,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = " geo:48.11638,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        // should be case insensitive
        geoURI = "GEO:48.11638,-122.77527"
        
        XCTAssertNoThrow(try formatter.location(from: geoURI))
    }
    
    // MARK: Latitude
    
    func testLatitudeParsing() throws {
        var geoURI = "geo:"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo: 48.11638,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
          XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638 ,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:xy.z,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo123.45, -122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }
    
    func testLatitudeRange() throws {
        var geoURI = "geo:90,-122.77527"
        var location = try formatter.location(from: geoURI)
        XCTAssertEqual(90.0, location.coordinate.latitude)
        
        geoURI = "geo:90.0000000001,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .invalidCoordinate)
        }
        
        geoURI = "geo:-90,-122.77527"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(-90.0, location.coordinate.latitude)
        
        geoURI = "geo:-90.0000000001,-122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .invalidCoordinate)
        }
    }
    
    // MARK: Longitude
    
    func testLongitudeParsing() throws {
        var geoURI = "geo:48.11638"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638, -122.77527"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,XXX"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,1234.56,"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }
    
    func testLongitudeRange() throws {
        formatter.options = [] // ensure normalizeLongitude is not an option

        var geoURI = "geo:48.11638,180"
        var location = try formatter.location(from: geoURI)
        XCTAssertEqual(180.0, location.coordinate.longitude)
        
        geoURI = "geo:48.11638,180.00000000001"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .invalidCoordinate)
        }
        
        geoURI = "geo:48.11638,-180"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(-180.0, location.coordinate.longitude)
        
        geoURI = "geo:48.11638,-180.00000000001"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .invalidCoordinate)
        }
    }
    
    func testLongitudeNormalization() throws {
        formatter.options = [.normalizeLongitude]
        
        // dateline normalization
        var geoURI = "geo:48.11638,-180"
        var location = try formatter.location(from: geoURI)
        XCTAssertEqual(180.0, location.coordinate.longitude)
        
        geoURI = "geo:90,-122.77527"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(0, location.coordinate.longitude)
        
        geoURI = "geo:-90,-122.77527"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(0, location.coordinate.longitude)
    }
    
    // MARK: Altitude
    
    func testAltitudeParsing() throws {
        
        formatter.parsingOptions = []
        
        var geoURI = "geo:48.11638,-122.77527"
        var location = try formatter.location(from: geoURI)
        XCTAssertEqual(.zero, location.altitude)
        
        geoURI = "geo:48.11638,-122.77527,0"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(.zero, location.altitude)
        
        geoURI = "geo:48.11638,-122.77527,1.23"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(1.23, location.altitude)
        
        geoURI = "geo:48.11638,-122.77527,-1.23"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(-1.23, location.altitude)
        
        geoURI = "geo:48.11638,-122.77527,"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,-122.77527, 0"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,-122.77527,1.23 "
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
        
        geoURI = "geo:48.11638,-122.77527,xyz"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }
    
    // MARK: CRS
    
    func testCrsParameter() throws {
        // If parameter is supplied, pattern should match
        var geoURI = "geo:48.11638,-122.77527;crs=wgs84"
        XCTAssertNoThrow(try formatter.location(from: geoURI))
        
        // Parameter name should be case insensitive
        geoURI = "geo:48.11638,-122.77527;CRS=wgs84"
        XCTAssertNoThrow(try formatter.location(from: geoURI))

        // Parameter value should be case insensitive
        geoURI = "geo:48.11638,-122.77527;crs=WGS84"
        XCTAssertNoThrow(try formatter.location(from: geoURI))

        geoURI = "geo:48.11638,-122.77527;crs=nad27"
        XCTAssertThrowsError(try formatter.location(from: geoURI)) { error in
            XCTAssertEqual(error as? ParsingError, .unsupportedCoordinateReferenceSystem(crs: "nad27"))
        }
    }
    
    // MARK: Uncertainty
    
    func testUncertaintyParameter() throws {
        var geoURI = "geo:48.11638,-122.77527;u=66.6"
        var location = try formatter.location(from: geoURI)
        XCTAssertEqual(66.6, location.horizontalAccuracy)
        XCTAssertEqual(.zero, location.verticalAccuracy)
        
        geoURI = "geo:48.11638,-122.77527,0;u=66.6"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(66.6, location.horizontalAccuracy)
        XCTAssertEqual(66.6, location.verticalAccuracy)
        
        geoURI = "geo:48.11638,-122.77527,123.45;u=66.6"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(66.6, location.horizontalAccuracy)
        XCTAssertEqual(66.6, location.verticalAccuracy)
        
        // Parameter name should be case insensitive
        geoURI = "geo:48.11638,-122.77527;U=66.6"
        location = try formatter.location(from: geoURI)
        XCTAssertEqual(66.6, location.horizontalAccuracy)
        XCTAssertEqual(.zero, location.verticalAccuracy)
        
        // An invalid value should not throw an error
        geoURI = "geo:48.11638,-122.77527;u=very"
        XCTAssertNoThrow(try formatter.location(from: geoURI))
    }
}
