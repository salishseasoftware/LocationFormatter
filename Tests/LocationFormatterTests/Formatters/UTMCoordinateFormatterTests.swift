import CoreLocation
import Numerics
import UTMConversion
import Testing
@testable import LocationFormatter

struct UTMCoordinateFormatterTests {

    @Test func stringFromCoordinate() {
        let formatter = UTMCoordinateFormatter()
        
        #expect(formatter.string(from: .portTownsend) == "10U 516726m E 5329260m N")
        #expect(formatter.string(from: .capeHorn) == "19F 607636m E 3794896m N")
        #expect(formatter.string(from: .seychelles) == "40M 329980m E 9482760m N")
        #expect(formatter.string(from: .faroeIslands) == "29V 611132m E 6883046m N")
        #expect(formatter.string(from: .nullIsland) == "31N 166021m E 000000m N")
        
        // Invalid coordinate should be nil
        #expect(formatter.string(from: CLLocationCoordinate2D(latitude: 91, longitude: -182)) == nil)
    }
    
    @Suite("Display option tests") struct StringFromCoordinate {
        @Test func noDisplayOptions() {
            let formatter = UTMCoordinateFormatter(displayOptions: [])
            #expect(formatter.string(from: .portTownsend) == "10U 516726m 5329260m")
        }
        
        @Test func suffixDisplayOption() {
            let formatter = UTMCoordinateFormatter(displayOptions: [.suffix])
            #expect(formatter.string(from: .portTownsend) == "10U 516726m E 5329260m N")
        }
        
        @Test func compactDisplayOption() {
            let formatter = UTMCoordinateFormatter(displayOptions: [.compact])
            #expect(formatter.string(from: .portTownsend) == "10U 516726m 5329260m")
        }
        
        @Test func compactAndSuffixDisplayOption() {
            let formatter = UTMCoordinateFormatter(displayOptions: [.compact, .suffix])
            #expect(formatter.string(from: .portTownsend) == "10U 516726mE 5329260mN")
        }
    }
    
    @Suite("Parsing tests") struct CoordinateFromString {
        @Test func latitudeBand() {
            let formatter = UTMCoordinateFormatter()
            
            
            #expect(throws: Never.self) {
                let coord = try formatter.coordinate(from: "10U 516726m E 5329260m N")
                #expect(coord.latitudeBand == UTMLatitudeBand.U)
            }
            
            // all other bands should not match
            UTMLatitudeBand.allCases.filter { $0 == .U }.forEach { band in
                guard band != .U else { return }
                #expect(throws: ParsingError.invalidLatitudeBand) {
                    try formatter.coordinate(from: "10\(band) 516726m E 5329260m N")
                }
            }
            
            // all uppercase letters that aren't bands, shouldn't match
            let bandCharacters = UTMLatitudeBand.allCases.map { Character($0.rawValue) }
            let invalidCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".filter { !bandCharacters.contains($0) }
            
            invalidCharacters.forEach { c in
                #expect(throws: ParsingError.noMatch) {
                    try formatter.coordinate(from: "10\(c) 516726m E 5329260m N")
                }
            }
        }
        
        @Suite("Easting") struct EastingParsing {
            @Test func tolerance() throws {
                let formatter = UTMCoordinateFormatter()
                let easting = try formatter.coordinate(from: "10U 516726m E 5329260m N").utmCoordinate().easting
                #expect(easting.isApproximatelyEqual(to: 516_726, absoluteTolerance: 0.00000001))
            }
            
            @Test("should not match 5 digits") func fiveDigits() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.noMatch) {
                    try formatter.coordinate(from: "10U 51672m E 5329260m N")
                }
            }
            
            @Test("should not match 7 digits") func sevenDigits() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.invalidLatitudeBand) {
                    try formatter.coordinate(from: "10U 5167260m E 5329260m N")
                }
            }
                
            @Test("should not match a decimal") func decimalNumber() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.noMatch) {
                    try formatter.coordinate(from: "10U 516726.6m E 5329260m N")
                }
            }
        }
        
        @Suite("Northing") struct NorthingParsing {
            @Test func tolerance() throws {
                let formatter = UTMCoordinateFormatter()
                let northing = try formatter.coordinate(from: "10U 516726m E 5329260m N").utmCoordinate().northing
                #expect(northing.isApproximatelyEqual(to: 5_329_260, absoluteTolerance: 1.0))
            }
            
            @Test("should not match 6 digits") func sixDigits() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.invalidLatitudeBand) {
                    try formatter.coordinate(from: "10U 516726m E 532926m N")
                }
            }
            
            @Test("should not match 8 digits") func eightDigits() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.invalidLatitudeBand) {
                    try formatter.coordinate(from: "10U 516726m E 53292601m N")
                }
            }
                
            @Test("should not match a decimal") func decimalNumber() throws {
                let formatter = UTMCoordinateFormatter()
                #expect(throws: ParsingError.noMatch) {
                    try formatter.coordinate(from: "10U 516726mm E 5329260.666m N")
                }
            }
        }
        
        @Suite struct CaseSensitivity {
            @Test func caseSensitve() throws {
                let formatter = UTMCoordinateFormatter(parsingOptions: [])
                
                #expect(throws: ParsingError.noMatch) {
                    try formatter.coordinate(from: "10u 516726m E 5329260m n")
                }
            }
            
            @Test func caseInsensitve() throws {
                let formatter = UTMCoordinateFormatter(parsingOptions: [.caseInsensitive])
                
                let coordinate = try formatter.coordinate(from: "10u 516726m E 5329260m n")
                
                #expect(coordinate.latitude.isApproximatelyEqual(to: 48.116380622937946, absoluteTolerance: 0.00001))
                #expect(coordinate.longitude.isApproximatelyEqual(to: -122.77527139988439, absoluteTolerance: 0.00001))
            }
        }
    }
}
