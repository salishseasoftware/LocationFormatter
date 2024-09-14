import CoreLocation
import Numerics
import Testing
@testable import LocationFormatter

@Suite struct LocationCoordinateFormatterTests {
    @Suite("String Generation") struct StringGeneration {
        @Test func decimalDegrees() {
            let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
            
            #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48.11638° N, 122.77527° W")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55.97917° S, 67.275° W")
            #expect(formatter.string(from: CLLocationCoordinate2D.seychelles) == "4.67785° S, 55.46718° E")
            #expect(formatter.string(from: CLLocationCoordinate2D.faroeIslands) == "62.06323° N, 6.87355° W")
            #expect(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland) == "51.37363° N, 179.41535° E")
            #expect(formatter.string(from: CLLocationCoordinate2D.nullIsland) == "0.0° N, 0.0° E")
        }
        
        @Test func degreesDecimalMinutes() {
            let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
            
            #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 06.983′ N, 122° 46.516′ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58.750′ S, 67° 16.500′ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.seychelles) == "4° 40.671′ S, 55° 28.031′ E")
            #expect(formatter.string(from: CLLocationCoordinate2D.faroeIslands) == "62° 03.794′ N, 6° 52.413′ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland) == "51° 22.418′ N, 179° 24.921′ E")
            #expect(formatter.string(from: CLLocationCoordinate2D.nullIsland) == "0° 00.000′ N, 0° 00.000′ E")
        }
        
        @Test func degreesMinutesSeconds() {
            let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
            
            #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 6′ 59″ N, 122° 46′ 31″ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58′ 45″ S, 67° 16′ 30″ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.seychelles) == "4° 40′ 40″ S, 55° 28′ 2″ E")
            #expect(formatter.string(from: CLLocationCoordinate2D.faroeIslands) == "62° 3′ 48″ N, 6° 52′ 25″ W")
            #expect(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland) == "51° 22′ 25″ N, 179° 24′ 55″ E")
            #expect(formatter.string(from: CLLocationCoordinate2D.nullIsland) == "0° 0′ 0″ N, 0° 0′ 0″ E")
        }
        
        @Test func utm() {
            let formatter = LocationCoordinateFormatter(format: .utm)
            
            #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "10U 516726m E 5329260m N")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "19F 607636m E 3794896m N")
            #expect(formatter.string(from: CLLocationCoordinate2D.seychelles) == "40M 329980m E 9482760m N")
            #expect(formatter.string(from: CLLocationCoordinate2D.faroeIslands) == "29V 611132m E 6883046m N")
            #expect(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland) == "60U 668108m E 5694144m N")
            #expect(formatter.string(from: CLLocationCoordinate2D.nullIsland) == "31N 166021m E 000000m N")
        }
        
        @Test func geoURI() {
            let formatter = LocationCoordinateFormatter(format: .geoURI)
            
            #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "geo:48.11638,-122.77527")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "geo:-55.97917,-67.275")
            #expect(formatter.string(from: CLLocationCoordinate2D.seychelles) == "geo:-4.67785,55.46718")
            #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "geo:-55.97917,-67.275")
            #expect(formatter.string(from: CLLocationCoordinate2D.faroeIslands) == "geo:62.06323,-6.87355")
            #expect(formatter.string(from: CLLocationCoordinate2D.pointNemo) == "geo:-48.876667,-123.393333")
            
        }
        
        @Suite struct SymbolStyle {
            @Test func none() {
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, symbolStyle: .none)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55.97917 S, 67.275 W")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, symbolStyle: .none)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55 58.750 S, 67 16.500 W")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, symbolStyle: .none)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55 58 45 S, 67 16 30 W")
            }
            
            @Test func simple() {
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, symbolStyle: .simple)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55.97917° S, 67.275° W")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, symbolStyle: .simple)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58.750' S, 67° 16.500' W")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, symbolStyle: .simple)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58' 45\" S, 67° 16' 30\" W")
            }
            
            @Test func traditional() {
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, symbolStyle: .traditional)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55.97917° S, 67.275° W")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, symbolStyle: .traditional)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58.750′ S, 67° 16.500′ W")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, symbolStyle: .traditional)
                #expect(formatter.string(from: CLLocationCoordinate2D.capeHorn) == "55° 58′ 45″ S, 67° 16′ 30″ W")
            }
        }
        
        @Suite struct DisplayOptions {
            @Test func empty() {
                let options: LocationFormatter.DisplayOptions = []
                
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48.11638°, -122.77527°")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 06.983′, -122° 46.516′")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 6′ 59″, -122° 46′ 31″")
                
                formatter = LocationCoordinateFormatter(format: .utm, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "10U 516726m 5329260m")
            }
            
            @Test func suffix() {
                let options: LocationFormatter.DisplayOptions = [.suffix]
                
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48.11638° N, 122.77527° W")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 06.983′ N, 122° 46.516′ W")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48° 6′ 59″ N, 122° 46′ 31″ W")
                
                formatter = LocationCoordinateFormatter(format: .utm, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "10U 516726m E 5329260m N")
            }
            
            @Test func compact() {
                let options: LocationFormatter.DisplayOptions  = [.compact]
                
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48.11638°, -122.77527°")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48°06.983′, -122°46.516′")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48°6′59″, -122°46′31″")
                
                formatter = LocationCoordinateFormatter(format: .utm, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "10U 516726m 5329260m")
            }
            
            @Test func compactSuffix() {
                let options: LocationFormatter.DisplayOptions  = [.compact, .suffix]
                
                var formatter = LocationCoordinateFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48.11638°N, 122.77527°W")
                
                formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48°06.983′N, 122°46.516′W")
                
                formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "48°6′59″N, 122°46′31″W")
                
                formatter = LocationCoordinateFormatter(format: .utm, displayOptions: options)
                #expect(formatter.string(from: CLLocationCoordinate2D.portTownsend) == "10U 516726mE 5329260mN")
            }
        }
    }
    
    // MARK: - String Parsing
    
    @Suite("String Parsing") struct StringParsing {
        @Suite struct DecimalDegrees {
            @Test(arguments: [
                ("48.11638° N, 122.77527° W", CLLocationCoordinate2D.portTownsend),
                ("4.67785° S, 55.46718° E", CLLocationCoordinate2D.seychelles),
                ("62.06323° N, 6.87355° W", CLLocationCoordinate2D.faroeIslands),
                ("51.37363° N, 179.41535° E", CLLocationCoordinate2D.amchitkaIsland),
                ("0.0° N, 0.0° E", CLLocationCoordinate2D.nullIsland)
                
            ]) func decimalDegrees(arg: (String, CLLocationCoordinate2D)) {
                let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: arg.0)
                    #expect(match.isApproximatelyEqual(to: arg.1, absoluteTolerance: 0.0001))
                }
            }
            
            @Test(arguments: [
                "-55.97917°, -67.275°",
                "55.97917°S,67.275°W",
                "55.97917 S, 67.275 W",
                "S 55.97917, W 67.275",
                "-55.97917, -67.275"
            ]) func patternMatching(string: String) {
                let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
            
            // Google uses a space instead of a comma as its delimiter for whatever reason
            @Test(arguments: [
                "55.97917°S 67.275°W",
                "-55.97917° -67.275°",
                "55.97917S 67.275W",
                "S55.97917 W67.275"
            ]) func googleFormat(string: String) {
                let formatter = LocationCoordinateFormatter(format: .decimalDegrees)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
        }
        
        @Suite struct DegreesDecimalMinutes {
            @Test(arguments: [
                ("48° 06.983′ N, 122° 46.516′ W", CLLocationCoordinate2D.portTownsend),
                ("4° 40.671′ S, 55° 28.031′ E", CLLocationCoordinate2D.seychelles),
                ("62° 03.794′ N, 6° 52.413′ W", CLLocationCoordinate2D.faroeIslands),
                ("51° 22.418′ N, 179° 24.921′ E", CLLocationCoordinate2D.amchitkaIsland),
                ("0° 00.000′ N, 0° 00.000′ E", CLLocationCoordinate2D.nullIsland)
                
            ]) func decimalDegrees(arg: (String, CLLocationCoordinate2D)) {
                let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: arg.0)
                    #expect(match.isApproximatelyEqual(to: arg.1, absoluteTolerance: 0.0001))
                }
            }
            
            @Test(arguments: [
                "55° 58.750′ S, 67° 16.500′ W",
                "-55° 58.750′, -67° 16.500′",
                "55°58.750′S,67°16.500′W",
                "55° 58.750' S, 67° 16.500' W",
                "S 55° 58.750′ S, W 67° 16.500′"
            ]) func patternMatching(string: String) {
                let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
            
            // Google uses a space instead of a comma as its delimiter for whatever reason
            @Test(arguments: [
                "55°58.750′S 67°16.500′W",
                "-55°58.750′ -67°16.500′",
                "55°58.750'S 67°16.500'W",
                "S55°58.750′S W67°16.500′"
            ]) func googleFormat(string: String) {
                let formatter = LocationCoordinateFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
        }
        
        @Suite struct DegreesMinutesSeconds {
            @Test(arguments: [
                ("48° 6′ 59″ N, 122° 46′ 31″ W", CLLocationCoordinate2D.portTownsend),
                ("4° 40′ 40″ S, 55° 28′ 2″ E", CLLocationCoordinate2D.seychelles),
                ("62° 3′ 48″ N, 6° 52′ 25″ W", CLLocationCoordinate2D.faroeIslands),
                ("51° 22′ 25″ N, 179° 24′ 55″ E", CLLocationCoordinate2D.amchitkaIsland),
                ("0° 0′ 0″ N, 0° 0′ 0″ E", CLLocationCoordinate2D.nullIsland)
                
            ]) func decimalDegrees(arg: (String, CLLocationCoordinate2D)) {
                let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: arg.0)
                    #expect(match.isApproximatelyEqual(to: arg.1, absoluteTolerance: 0.001))
                }
            }
            
            @Test(arguments: [
                "55° 58′ 45″ S, 67° 16′ 30″ W",
                "-55° 58′ 45″, -67° 16′ 30″",
                "55°58′45″S,67°16′30″W",
                "55° 58' 45\" S, 67° 16' 30\" W",
                "S 55° 58′ 45″, W 67° 16′ 30″",
                "55°58′45″S, 67°16′30″W",
                "55 58 45 S, 67 16 30 W",
            ]) func patternMatching(string: String) {
                let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
            
            // Google uses a space instead of a comma as its delimiter for whatever reason
            @Test(arguments: [
                "55°58′45″S 67°16′30″W",
                "55°58'45\"S 67°16'30\"W",
                "S55°58′45″ W67°16′30″",
                "55°58′45″S 67°16′30″W"
            ]) func googleFormat(string: String) {
                let formatter = LocationCoordinateFormatter(format: .degreesMinutesSeconds)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.capeHorn,
                        absoluteTolerance: 0.0001
                    ))
                }
            }
        }
        
        @Suite struct UTM {
            @Test(arguments: [
                ("10U 516726m E 5329260m N", CLLocationCoordinate2D.portTownsend),
                ("19F 607636m E 3794896m N", CLLocationCoordinate2D.capeHorn),
                ("40M 329980m E 9482760m N", CLLocationCoordinate2D.seychelles),
                ("29V 611132m E 6883046m N", CLLocationCoordinate2D.faroeIslands),
                ("60U 668108m E 5694144m N", CLLocationCoordinate2D.amchitkaIsland),
                ("31N 166021m E 000000m N", CLLocationCoordinate2D.nullIsland)
                
            ]) func decimalDegrees(arg: (String, CLLocationCoordinate2D)) {
                let formatter = LocationCoordinateFormatter(format: .utm)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: arg.0)
                    #expect(match.isApproximatelyEqual(to: arg.1, absoluteTolerance: 0.00001))
                }
            }
            
            @Test(arguments: [
                "10U 516726mE 5329260mN",
                "10U   516726m E   5329260m N",
                "10U 516726M e 5329260m n"
            ]) func utm(string: String) {
                let formatter = LocationCoordinateFormatter(format: .utm)
                
                #expect(throws: Never.self) {
                    let match = try formatter.coordinate(from: string)
                    #expect(match.isApproximatelyEqual(
                        to: CLLocationCoordinate2D.portTownsend,
                        absoluteTolerance: 0.00001
                    ))
                }
            }
            
            @Test func latitudeBandIsRequired() {
                let formatter = LocationCoordinateFormatter(format: .utm)
                // Latitude band is required because without it we cant determine the correct latitude.
                #expect(throws: ParsingError.noMatch) {
                    try formatter.location(from: "11 727771mE 5193170mN")
                }
            }
        }
    }
}
