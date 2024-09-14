import CoreLocation
import Numerics
import UTMConversion
import Testing
@testable import LocationFormatter

@Suite struct LocationDegreesFormatterTests {
    
    @Test func format() {
        let degrees = CLLocationDegrees(-55.97917)
        let formatted = degrees.formatted(CLLocationDegrees.FormatStyle().symbolStyle(.traditional))
        #expect(formatted == "-55.97917°")
    }

    @Suite("String Generation") struct StringGeneration {
        @Suite struct DecimalDegrees {
            @Test func orientationNone() {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(formatter.string(from: -55.97917) == "-55.97917°")
                #expect(formatter.string(from: -67.275) == "-67.275°")
                
                #expect(formatter.string(from: -4.67785 ) == "-4.67785°")
                #expect(formatter.string(from: 55.46718 ) == "55.46718°")
                
                #expect(formatter.string(from: 62.06323 ) == "62.06323°")
                #expect(formatter.string(from: -6.87355 ) == "-6.87355°")
                
                #expect(formatter.string(from: 51.37363 ) == "51.37363°")
                #expect(formatter.string(from: 179.41535 ) == "179.41535°")
                
                #expect(formatter.string(from: 0.0 ) == "0.0°")
            }
            
            @Test func orientationLatitude() {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55.97917° S")
                #expect(formatter.string(from: -4.67785, orientation: .latitude) == "4.67785° S")
                #expect(formatter.string(from: 62.06323, orientation: .latitude) == "62.06323° N")
                #expect(formatter.string(from: 51.37363, orientation: .latitude) == "51.37363° N")
                #expect(formatter.string(from: 0.0, orientation: .latitude) == "0.0° N")
            }
            
            @Test func orientationLongitude() {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67.275° W")
                #expect(formatter.string(from: 55.46718, orientation: .longitude) ==  "55.46718° E")
                #expect(formatter.string(from: -6.87355, orientation: .longitude) == "6.87355° W")
                #expect(formatter.string(from: 179.41535, orientation: .longitude) == "179.41535° E")
                #expect(formatter.string(from: 0.0, orientation: .longitude) == "0.0° E")
            }
        }
        
        @Suite struct DecimalDegreesMinutes {
            @Test func orientationNone() {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .traditional)
                
                #expect(formatter.string(from: -55.97917 ) == "-55° 58.750′")
                #expect(formatter.string(from: -67.275 ) == "-67° 16.500′")
                
                #expect(formatter.string(from: -4.67785 ) == "-4° 40.671′")
                #expect(formatter.string(from: 55.46718 ) == "55° 28.031′")
                
                #expect(formatter.string(from: 62.06323 ) == "62° 03.794′")
                #expect(formatter.string(from: -6.87355 ) == "-6° 52.413′")
                
                #expect(formatter.string(from: 51.37363 ) == "51° 22.418′")
                #expect(formatter.string(from: 179.41535 ) == "179° 24.921′")
                
                #expect(formatter.string(from: 0.0 ) == "0° 00.000′")
            }
            
            @Test func orientationLatitude() {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .traditional)
                
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55° 58.750′ S")
                #expect(formatter.string(from: -4.67785, orientation: .latitude) == "4° 40.671′ S")
                #expect(formatter.string(from: 62.06323, orientation: .latitude) == "62° 03.794′ N")
                #expect(formatter.string(from: 51.37363, orientation: .latitude) == "51° 22.418′ N")
                #expect(formatter.string(from: 0.0, orientation: .latitude) == "0° 00.000′ N")
            }
            
            @Test func orientationLongitude() {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .traditional)
                
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67° 16.500′ W")
                #expect(formatter.string(from: 55.46718, orientation: .longitude) == "55° 28.031′ E")
                #expect(formatter.string(from: -6.87355, orientation: .longitude) == "6° 52.413′ W")
                #expect(formatter.string(from: 179.41535, orientation: .longitude) == "179° 24.921′ E")
                #expect(formatter.string(from: 0.0, orientation: .longitude) == "0° 00.000′ E")
            }
        }
        
        @Suite struct DegreesMinutesSeconds {
            @Test func orientationNone() {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .traditional, displayOptions: [.suffix])
                
                #expect(formatter.string(from: -55.97917 ) == "-55° 58′ 45″")
                #expect(formatter.string(from: -67.275 ) == "-67° 16′ 30″")
                
                #expect(formatter.string(from: -4.67785 ) == "-4° 40′ 40″")
                #expect(formatter.string(from: 55.46718 ) == "55° 28′ 2″")
                
                #expect(formatter.string(from: 62.06323 ) == "62° 3′ 48″")
                #expect(formatter.string(from: -6.87355 ) == "-6° 52′ 25″")
                
                #expect(formatter.string(from: 51.37363 ) == "51° 22′ 25″")
                #expect(formatter.string(from: 179.41535 ) == "179° 24′ 55″")
                
                #expect(formatter.string(from: 0.0 ) == "0° 0′ 0″")
            }
            
            @Test func orientationLatitude() {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .traditional, displayOptions: [.suffix])
                
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55° 58′ 45″ S")
                #expect(formatter.string(from: -4.67785, orientation: .latitude) == "4° 40′ 40″ S")
                #expect(formatter.string(from: 62.06323, orientation: .latitude) == "62° 3′ 48″ N")
                #expect(formatter.string(from: 51.37363, orientation: .latitude) == "51° 22′ 25″ N")
                #expect(formatter.string(from: 0.0, orientation: .latitude) == "0° 0′ 0″ N")
            }
            
            @Test func orientationLongitude() {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .traditional, displayOptions: [.suffix])
                
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67° 16′ 30″ W")
                #expect(formatter.string(from: 55.46718, orientation: .longitude) == "55° 28′ 2″ E")
                #expect(formatter.string(from: -6.87355, orientation: .longitude) == "6° 52′ 25″ W")
                #expect(formatter.string(from: 179.41535, orientation: .longitude) == "179° 24′ 55″ E")
                #expect(formatter.string(from: 0.0, orientation: .longitude) == "0° 0′ 0″ E")
            }
        }
        
        @Suite struct SymbolStyle {
            @Test func none() {
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, symbolStyle: .none, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55.97917")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67.275")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .none, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55 58.750")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67 16.500")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .none, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55 58 45")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67 16 30")
            }
            
            @Test func simple() {
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, symbolStyle: .simple, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55.97917°")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67.275°")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .simple, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58.750'")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67° 16.500'")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .simple, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58' 45\"")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67° 16' 30\"")
            }
            
            @Test func traditional() {
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, symbolStyle: .traditional, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55.97917°")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67.275°")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, symbolStyle: .traditional, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58.750′")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67° 16.500′")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, symbolStyle: .traditional, displayOptions: [])
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58′ 45″")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67° 16′ 30″")
            }
        }
        
        @Suite struct DisplayOptions {
            @Test func empty() {
                let options: LocationFormatter.DisplayOptions = []
                
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55.97917°")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67.275°")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58.750′")
                #expect(formatter.string(from: -67.275, orientation: .longitude) ==  "-67° 16.500′")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55° 58′ 45″")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67° 16′ 30″")
            }
            
            @Test func suffix() {
                let options: LocationFormatter.DisplayOptions = [.suffix]
                
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55.97917° S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67.275° W")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55° 58.750′ S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) ==  "67° 16.500′ W")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55° 58′ 45″ S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67° 16′ 30″ W")
            }
            
            @Test func compact() {
                let options: LocationFormatter.DisplayOptions  = [.compact]
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55.97917°")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67.275°")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55°58.750′")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67°16.500′")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "-55°58′45″")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "-67°16′30″")
            }
            
            @Test func compactSuffix() {
                let options: LocationFormatter.DisplayOptions  = [.compact, .suffix]
                var formatter = LocationDegreesFormatter(format: .decimalDegrees, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55.97917°S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67.275°W")
                
                formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55°58.750′S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67°16.500′W")
                
                formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds, displayOptions: options)
                #expect(formatter.string(from: -55.97917, orientation: .latitude) == "55°58′45″S")
                #expect(formatter.string(from: -67.275, orientation: .longitude) == "67°16′30″W")
            }
        }
    }
    
    // MARK: -
    
    @Suite() struct StringParsing {
        @Suite struct DecimalDegrees {
            @Test(arguments: [
                "55.97917° S",
                "55.97917°S",
                "-55.97917°",
                "-55.97917",
                "55.97917S",
                "-55.97917000000123"
            ])
            func decimalDegrees(string: String) {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)

                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees
                        .isApproximatelyEqual(
                            to: CLLocationCoordinate2D.capeHorn.latitude,
                            absoluteTolerance: 0.000001
                        )
                    )
                }
            }
            
            @Test(arguments: [
                "S 55.97917°",
                "S55.97917°",
                "s 55.97917°",
                "55.97917° s",
                "S 55.97917° s"
            ]) func direction(string: String) {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees
                        .isApproximatelyEqual(
                            to: CLLocationCoordinate2D.capeHorn.latitude,
                            absoluteTolerance: 0.001
                        )
                    )
                }
            }
            
            @Test(arguments: [
                "55° 58.750′ S",
                "-55 58 45"
            ]) func noMatch(string: String) {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(throws: ParsingError.noMatch) {
                    try formatter.locationDegrees(from: string)
                }
            }
            
            @Test(arguments: [
                "180.0001° S",
                "180.0001°"
                
            ]) func invalidRangeDegrees(string: String) {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(
                    throws: ParsingError.invalidRangeDegrees,
                    "Expected 'DDM' format to not match 'DD' format."
                ) {
                    try formatter.locationDegrees(from: string)
                }
            }
            
            @Test func conflict() {
                let formatter = LocationDegreesFormatter(format: .decimalDegrees)
                
                #expect(throws: ParsingError.conflict) {
                    try formatter.locationDegrees(from: "S 55.97917° N")
                }
            }
        }
        
        @Suite struct DegreesDecimalMinutes {
            let expected = CLLocationCoordinate2D.capeHorn.latitude
            
            @Test(arguments:[
                "55° 58.750′ S",
                "55° 58.750' S",
                "55°58.750′S",
                "-55°58.750′",
                "55 58.750′ S",
                "55 58.750 S",
                "-55 58.750"
            ]) func degreesDecimalMinutes(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees == CLLocationCoordinate2D.capeHorn.latitude)
                }
            }
            
            @Test(arguments: [
                "-55° 58.750′",
                "55° 58.750′ W",
                "55° 58.750′ w",
                "55° 58.750′W"
            ]) func directionSuffix(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees
                        .isApproximatelyEqual(
                            to: CLLocationCoordinate2D.capeHorn.latitude,
                            absoluteTolerance: 0.001
                        )
                    )
                }
            }
                
            @Test(arguments: [
                "W 55° 58.750′",
                "w 55° 58.750′",
                "W55° 58.750′"
            ]) func directionPrefix(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees == CLLocationCoordinate2D.capeHorn.latitude)
                }
            }
            
            @Test func noMatch() {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DD' format to not match 'DDM' format."
                ) {
                    try formatter.locationDegrees(from: "-55.97917")
                }

                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DMS' format to not match 'DDM' format."
                ) {
                    try formatter.locationDegrees(from: "-55 58 45")
                }
            }
            
            @Test(arguments: [
                "47° 60.1′ N",
                "47° 60.001′ S",
                "20° 60.001′ E",
                "120° 60.001′ W"
            ]) func invalidRangeMinutes(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: ParsingError.invalidRangeMinutes) {
                    try formatter.locationDegrees(from: string)
                }
            }
            
            @Test(arguments: [
                "180° 00.01′ E",
                "180° 00.001′ W",
                "-180° 00.01′",
                "90° 01.001′ N",
                "90° 01.001′ S"
            ]) func invalidRangeDegrees(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesDecimalMinutes)
                
                #expect(throws: ParsingError.invalidRangeDegrees) {
                    try formatter.locationDegrees(from: string)
                }
            }
        }
        
        @Suite struct DegreesMinutesSeconds {
            let expected = CLLocationCoordinate2D.capeHorn.latitude
            
            @Test(arguments: [
                "-55° 58′ 45\"",
                "-55° 58' 45\"",
                "-55 58 45",
                "-55°58′45\"",
                "55° 58′ 45″ S",
                "55° 58′ 45″ s",
                "55°58′45″S",
                "-55°58′45″",
                "-55° 58′ 45″ S",
                "S 55° 58′ 45″",
                "s 55° 58′ 45″",
                "S55°58′45″",
                "S -55° 58′ 45″",
                "S 55° 58′ 45″ S",
            ]) func degreesMinutesSeconds(string: String) {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds)

                #expect(throws: Never.self) {
                    let locationDegrees = try formatter.locationDegrees(from: string)
                    #expect(locationDegrees
                        .isApproximatelyEqual(
                            to: CLLocationCoordinate2D.capeHorn.latitude,
                            absoluteTolerance: 0.0000001
                        )
                    )
                }
            }
            
            @Test func noMatch() {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds)

                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DD' format to not match 'DMS' format."
                ) {
                    try formatter.locationDegrees(from: "55.97917° S")
                }
                
                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DD' format to not match 'DMS' format."
                ) {
                    try formatter.locationDegrees(from: "-55.97917")
                }
                
                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DDM' format to not match 'DMS' format."
                ) {
                    try formatter.locationDegrees(from: "55° 58.750′ S")
                }
                
                #expect(
                    throws: ParsingError.noMatch,
                    "Expected 'DDM' format to not match 'DMS' format."
                ) {
                    try formatter.locationDegrees(from: "-55 58.750")
                }
                
                #expect(
                    throws: ParsingError.noMatch,
                    "Expected prefix to not match."
                ) {
                    try formatter.locationDegrees(from: "South 55° 58′ 45″")
                }
            }
            
            @Test func conflict() {
                let formatter = LocationDegreesFormatter(format: .degreesMinutesSeconds)

                #expect(
                    throws: ParsingError.conflict,
                    "Expected conflicting prefix and suffix."
                ) {
                    try formatter.locationDegrees(from: "w 55° 58′ 45″ S")
                }
            }
        }
    }
}
