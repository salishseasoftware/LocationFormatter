import CoreLocation
import UTMConversion
import Testing
import Numerics
@testable import LocationFormatter

struct UTMCoordinateFormatStyleTests {

    @Test(arguments: [
        (CLLocationCoordinate2D.portTownsend, "10U 516726m E 5329260m N"),
        (CLLocationCoordinate2D.capeHorn, "19F 607636m E 3794896m N"),
        (CLLocationCoordinate2D.seychelles, "40M 329980m E 9482760m N"),
        (CLLocationCoordinate2D.faroeIslands, "29V 611132m E 6883046m N"),
        (CLLocationCoordinate2D.nullIsland, "31N 166021m E 0000000m N")
    ]) func formatted(arg: (CLLocationCoordinate2D, String)) throws {
        let utm = try arg.0.utmCoordinate()
        #expect(utm.formatted() == arg.1)
    }
    
    @Test(arguments: [
        (CLLocationCoordinate2D.portTownsend, "10U 516726mE 5329260mN"),
        (CLLocationCoordinate2D.capeHorn, "19F 607636mE 3794896mN"),
        (CLLocationCoordinate2D.seychelles, "40M 329980mE 9482760mN"),
        (CLLocationCoordinate2D.faroeIslands, "29V 611132mE 6883046mN"),
        (CLLocationCoordinate2D.nullIsland, "31N 166021mE 0000000mN")
    ]) func compact(arg: (CLLocationCoordinate2D, String)) throws {
        let utm = try arg.0.utmCoordinate()
        #expect(utm.formatted(.compact) == arg.1)
    }
    
    @Test(arguments: [
        (CLLocationCoordinate2D.portTownsend, "10U 516726m 5329260m"),
        (CLLocationCoordinate2D.capeHorn, "19F 607636m 3794896m"),
        (CLLocationCoordinate2D.seychelles, "40M 329980m 9482760m"),
        (CLLocationCoordinate2D.faroeIslands, "29V 611132m 6883046m"),
        (CLLocationCoordinate2D.nullIsland, "31N 166021m 0000000m")
    ]) func short(arg: (CLLocationCoordinate2D, String)) throws {
        let utm = try arg.0.utmCoordinate()
        #expect(utm.formatted(.short) == arg.1)
    }
    
    @Suite("Parsing tests") struct StringParsing {
        @Test func parsing() throws {
            let utm = try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 5329260m N")
            #expect(utm.zone == 10)
            #expect(utm.northing  ==  5_329_260)
            #expect(utm.easting  ==  516_726)
            #expect(utm.hemisphere  == .northern)
        }
        
        @Suite struct LatitudeBandParsing {
            @Test func latitudeBand() throws {
                let utm = try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 5329260m N")
                #expect(utm.coordinate().latitudeBand == .U)
            }
            
            @Test func invalidLatitudeBand() {
                // all other bands should not match
                UTMLatitudeBand.allCases.filter { $0 == .U }.forEach { band in
                    guard band != .U else { return }
                    #expect(throws: ParsingError.invalidLatitudeBand) {
                        try UTMCoordinate.FormatStyle().parseStrategy.parse("10\(band) 516726m E 5329260m N")
                    }
                }
            }
            
            @Test func moMatchingBand() {
                // all uppercase letters that aren't bands, shouldn't match
                let bandCharacters = UTMLatitudeBand.allCases.map { Character($0.rawValue) }
                let invalidCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".filter { !bandCharacters.contains($0) }
                invalidCharacters.forEach { c in
                    #expect(throws: ParsingError.noMatch) {
                        try UTMCoordinate.FormatStyle().parseStrategy.parse("10\(c) 516726m E 5329260m N")
                    }
                }
            }
        }
        
        @Suite struct EastingParsing {
            @Test func tolerance() throws {
                let utm = try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 5329260m N")
                #expect(utm.easting.isApproximatelyEqual(to: 516_726, absoluteTolerance: 0.00000001))
            }
                
            @Test("should not match 5 digits") func fiveDigits() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 51672m E 5329260m N")
                }
            }
            
            @Test("should not match 8 digits") func eightDigits() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 51672608m E 5329260m N")
                }
            }
                
            @Test("should not match a decimal") func decimalNumber() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726.6m E 5329260m N")
                }
            }
        }
        
        @Suite("Northing") struct NorthingParsing {
            @Test func tolerance() throws {
                let utm = try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 5329260m N")
                #expect(utm.northing.isApproximatelyEqual(to: 5_329_260, absoluteTolerance: 1.0))
            }
            
            @Test("should not match 5 digits") func fiveDigits() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 53292m N")
                }
            }
            
            @Test("should not match 8 digits") func eightDigits() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726m E 53292601m N")
                }
            }
                
            @Test("should not match a decimal") func decimalNumber() throws {
                #expect(throws: ParsingError.noMatch) {
                    try UTMCoordinate.FormatStyle().parseStrategy.parse("10U 516726mm E 5329260.666m N")
                }
            }
        }
    }
}
