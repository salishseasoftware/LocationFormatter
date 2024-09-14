import CoreLocation
import UTMConversion
import Testing
@testable import LocationFormatter

@Suite struct GeoURILocationFormatterTests {

    @Suite struct GeoURIStringGeneration {
        @Test func stringFromLocation() {
            let formatter = GeoURILocationFormatter()
            
            #expect(formatter.string(fromLocation: .mountEverest) == "geo:27.988056,86.925278,8848.86;u=0.21")
            #expect(formatter.string(fromLocation: .challengerDeep) == "geo:11.373333,142.591667,-10920;u=10")
            #expect(formatter.string(fromLocation: .pointNemo) == "geo:-48.876667,-123.393333")
        }
        
        @Test func stringFromCoordinate() {
            let formatter = GeoURILocationFormatter()
            
            #expect(formatter.string(fromCoordinate: .portTownsend) == "geo:48.11638,-122.77527")
            #expect(formatter.string(fromCoordinate: .capeHorn) == "geo:-55.97917,-67.275")
            #expect(formatter.string(fromCoordinate: .seychelles) == "geo:-4.67785,55.46718")
            #expect(formatter.string(fromCoordinate: .capeHorn) == "geo:-55.97917,-67.275")
            #expect(formatter.string(fromCoordinate: .faroeIslands) == "geo:62.06323,-6.87355")
            #expect(formatter.string(fromCoordinate: .pointNemo) == "geo:-48.876667,-123.393333")
        }
        
        @Test func includeCRS() {
            let formatter = GeoURILocationFormatter(options: [.includeCRS])
            
            #expect(formatter.string(fromLocation: .mountEverest) == "geo:27.988056,86.925278,8848.86;crs=wgs84;u=0.21")
            #expect(formatter.string(fromLocation: .challengerDeep) == "geo:11.373333,142.591667,-10920;crs=wgs84;u=10")
            #expect(formatter.string(fromLocation: .pointNemo) == "geo:-48.876667,-123.393333;crs=wgs84")
        }
    }
    
    @Suite struct GeoURIStringParsing {
        @Test func locationFromString() throws {
            let formatter = GeoURILocationFormatter()
            
            let mountEverest = try formatter.location(from: "geo:27.988056,86.925278,8848.86;u=0.21")
            #expect(mountEverest.coordinate.latitude == 27.988056)
            #expect(mountEverest.coordinate.longitude == 86.925278)
            #expect(mountEverest.altitude == 8_848.86)
            #expect(mountEverest.horizontalAccuracy == 0.21)
            #expect(mountEverest.verticalAccuracy == 0.21)
            
            let challengerDeep = try formatter.location(from: "geo:11.373333,142.591667,-10920;u=10")
            #expect(challengerDeep.coordinate.latitude == 11.373333)
            #expect(challengerDeep.coordinate.longitude == 142.591667)
            #expect(challengerDeep.altitude == -10_920)
            #expect(challengerDeep.horizontalAccuracy == 10.0)
            #expect(challengerDeep.verticalAccuracy == 10.0)
            
            let pointNemo = try formatter.location(from: "geo:-48.876667,-123.393333")
            #expect(pointNemo.coordinate.latitude == -48.876667)
            #expect(pointNemo.coordinate.longitude == -123.393333)
            #expect(pointNemo.altitude == .zero)
            #expect(pointNemo.horizontalAccuracy == .zero)
            #expect(pointNemo.verticalAccuracy == .zero)
        }
        
        @Test(arguments: [
            "geo48.11638,-122.77527",
            "geo://48.11638,-122.77527",
            " geo:48.11638,-122.77527"
        ]) func schemeParsing(string: String) {
            let formatter = GeoURILocationFormatter()
            
            #expect(throws: ParsingError.noMatch) {
                try formatter.location(from: string)
            }
        }
        
        @Test func caseInsensitive() {
            let formatter = GeoURILocationFormatter(parsingOptions: [.caseInsensitive])
            
            // should be case insensitive
            #expect(throws: Never.self) {
                try formatter.location(from: "GEO:48.11638,-122.77527")
            }
        }
        
        @Suite struct LatitudeParsing {
            @Test() func latitudeParsing() throws {
                let formatter = GeoURILocationFormatter()
                
                let location = try formatter.location(from: "geo:48.11638,180")
                #expect(location.coordinate.latitude == 48.11638)
            }
            
            @Test(arguments: [
                "geo: 48.11638,-122.77527",
                "geo:,-122.77527",
                "geo:",
                "geo:48.11638 ,-122.77527",
                "geo:xy.z,-122.77527",
                "geo123.45, -122.77527",
            ]) func noMatch(string: String) {
                let formatter = GeoURILocationFormatter()
                
                #expect(throws: ParsingError.noMatch) {
                    try formatter.location(from: string)
                }
            }
            
            @Test() func latitudeRange() throws {
                let formatter = GeoURILocationFormatter()
                
                var location = try formatter.location(from: "geo:90,-122.77527")
                #expect(location.coordinate.latitude == 90.0)
                
                #expect(throws: ParsingError.invalidCoordinate) {
                    try formatter.location(from: "geo:90.0000000001,-122.77527")
                }
                
                location = try formatter.location(from: "geo:-90,-122.77527")
                #expect(location.coordinate.latitude == -90.0)
                
                #expect(throws: ParsingError.invalidCoordinate) {
                    try formatter.location(from: "geo:-90.0000000001,-122.77527")
                }
            }
        }
        
        @Suite struct LongitudeParsing {
            @Test() func longitudeParsing() throws {
                let formatter = GeoURILocationFormatter()
                
                let location = try formatter.location(from: "geo:48.11638,180")
                #expect(location.coordinate.longitude == 180.0)
                
            }
            
            @Test(arguments: [
                "geo:",
                "geo:48.11638",
                "geo:48.11638, -122.77527",
                "geo:48.11638,XXX",
                "geo:48.11638,1801.11,"
            ]) func noMatch(string: String) throws {
                let formatter = GeoURILocationFormatter()
                
                #expect(throws: ParsingError.noMatch) {
                    try formatter.location(from: string)
                }
            }
            
            @Test() func longitudeRange() throws {
                let formatter = GeoURILocationFormatter()
                
                var location = try formatter.location(from: "geo:48.11638,180")
                #expect(location.coordinate.longitude.isApproximatelyEqual(to: 180.0, absoluteTolerance: 0.000001))
                
                #expect(throws: ParsingError.invalidCoordinate) {
                    try formatter.location(from: "geo:48.11638,180.00000000001")
                }
                
                location = try formatter.location(from: "geo:48.11638,-180")
                #expect(location.coordinate.longitude.isApproximatelyEqual(to: 180.0, absoluteTolerance: 0.000001))
                
                #expect(throws: ParsingError.invalidCoordinate) {
                    try formatter.location(from: "geo:48.11638,-180.00000000001")
                }
            }
            
            @Test() func longitudeNormalization() throws {
                let formatter = GeoURILocationFormatter(options: [.normalizeLongitude])
                
                var location = try formatter.location(from: "geo:48.11638,-180")
                #expect(location.coordinate.longitude == 180.0)
                
                location = try formatter.location(from: "geo:90,-122.77527")
                #expect(location.coordinate.longitude == 0.0)
                
                location = try formatter.location(from: "geo:-90,-122.77527")
                #expect(location.coordinate.longitude == 0.0)
            }
        }
        
        @Suite struct AltitudeParsing {
            @Test() func altitudeParsing() throws {
                let formatter = GeoURILocationFormatter()
                
                var location = try formatter.location(from: "geo:48.11638,-122.77527")
                #expect(location.altitude == .zero)
                
                location = try formatter.location(from: "geo:48.11638,-122.77527,0")
                #expect(location.altitude == .zero)
                
                location = try formatter.location(from: "geo:48.11638,-122.77527,1.23")
                #expect(location.altitude == 1.23)
                
                location = try formatter.location(from: "geo:48.11638,-122.77527,-1.23")
                #expect(location.altitude == -1.23)
            }
            
            @Test(arguments: [
                "geo:48.11638,-122.77527,",
                "geo:48.11638,-122.77527, 0",
                "geo:48.11638,-122.77527,1.23 ",
                "geo:48.11638,-122.77527,xyz"
            ]) func noMatch(string: String) {
                let formatter = GeoURILocationFormatter()
                
                #expect(throws: ParsingError.noMatch) {
                    try formatter.location(from: string)
                }
            }
        }
        
        @Suite struct CRS {
            @Test(arguments: [
                "geo:48.11638,-122.77527;crs=wgs84", // If crs parameter is supplied, pattern should match
                "geo:48.11638,-122.77527;CRS=wgs84", // Parameter name should be case insensitive
                "geo:48.11638,-122.77527;crs=WGS84" // Parameter value should be case insensitive
                
            ]) func crsParameterParsing(string: String) {
                let formatter = GeoURILocationFormatter()
                
                #expect(throws: Never.self) {
                    try formatter.location(from: string)
                }
            }
            
            @Test func unsupportedCoordinateReferenceSystem() {
                let formatter = GeoURILocationFormatter()
                
                #expect {
                    try formatter.location(from: "geo:48.11638,-122.77527;crs=nad27")
                } throws: { error in
                    guard let parsingError = error as? ParsingError,
                          case let .unsupportedCoordinateReferenceSystem(crs) = parsingError
                    else {
                        return false
                    }
                    return crs == "nad27"
                }
            }
        }
        
        @Test() func uncertaintyParameterParsing() throws {
            let formatter = GeoURILocationFormatter()
            
            var location = try formatter.location(from: "geo:48.11638,-122.77527;u=66.6")
            #expect(location.horizontalAccuracy == 66.6)
            #expect(location.verticalAccuracy == .zero)
            
            location = try formatter.location(from: "geo:48.11638,-122.77527,0;u=66.6")
            #expect(location.horizontalAccuracy == 66.6)
            #expect(location.verticalAccuracy == 66.6)
            
            location = try formatter.location(from: "geo:48.11638,-122.77527,123.45;u=66.6")
            #expect(location.horizontalAccuracy == 66.6)
            #expect(location.verticalAccuracy == 66.6)
            
            
            // Parameter name should be case insensitive
            location = try formatter.location(from: "geo:48.11638,-122.77527;U=66.6")
            #expect(location.horizontalAccuracy == 66.6)
            #expect(location.verticalAccuracy == .zero)
            
            // An invalid value should be ignored, and not throw an error
            #expect(throws: Never.self) {
                let location = try formatter.location(from: "geo:48.11638,-122.77527;u=very")
                #expect(location.horizontalAccuracy == .zero)
                #expect(location.verticalAccuracy == .zero)
            }
        }
    }
}
