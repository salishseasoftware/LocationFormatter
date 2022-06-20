import CoreLocation
@testable import LocationFormatter
import XCTest

class LocationCoordinateFormatterTests: XCTestCase {
    private var formatter: LocationCoordinateFormatter!

    override func setUpWithError() throws {
        formatter = LocationCoordinateFormatter()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        formatter = nil
        try super.tearDownWithError()
    }

    // MARK: - String Formatting

    // MARK: DD

    func test_ddString() throws {
        formatter.format = .decimalDegrees
        formatter.symbolStyle = .traditional

        XCTAssertEqual("48.11638° N, 122.77527° W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55.97917° S, 67.275° W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4.67785° S, 55.46718° E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62.06323° N, 6.87355° W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51.37363° N, 179.41535° E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0.0° N, 0.0° E", formatter.string(from: CLLocationCoordinate2D.nullIsland))

        formatter.displayOptions = []
        XCTAssertEqual("48.11638°, -122.77527°", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        
        formatter.displayOptions = [.suffix]
        XCTAssertEqual("48.11638° N, 122.77527° W", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("48.11638°, -122.77527°", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.suffix, .compact]
        XCTAssertEqual("48.11638°N, 122.77527°W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
    }

    // MARK: DDM

    func test_ddmString() throws {
        formatter.format = .degreesDecimalMinutes
        formatter.symbolStyle = .traditional

        XCTAssertEqual("48° 06.983′ N, 122° 46.516′ W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55° 58.750′ S, 67° 16.500′ W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4° 40.671′ S, 55° 28.031′ E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62° 03.794′ N, 6° 52.413′ W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51° 22.418′ N, 179° 24.921′ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0° 00.000′ N, 0° 00.000′ E", formatter.string(from: CLLocationCoordinate2D.nullIsland))

        formatter.displayOptions = []
        XCTAssertEqual("48° 06.983′, -122° 46.516′", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        
        formatter.displayOptions = [.suffix]
        XCTAssertEqual("48° 06.983′ N, 122° 46.516′ W", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("48°06.983′, -122°46.516′", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.suffix, .compact]
        XCTAssertEqual("48°06.983′N, 122°46.516′W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
    }

    // MARK: DMS

    func test_dmsString() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.symbolStyle = .traditional

        XCTAssertEqual("48° 6′ 59″ N, 122° 46′ 31″ W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55° 58′ 45″ S, 67° 16′ 30″ W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4° 40′ 40″ S, 55° 28′ 2″ E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62° 3′ 48″ N, 6° 52′ 25″ W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51° 22′ 25″ N, 179° 24′ 55″ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0° 0′ 0″ N, 0° 0′ 0″ E", formatter.string(from: CLLocationCoordinate2D.nullIsland))

        formatter.displayOptions = []
        XCTAssertEqual("48° 6′ 59″, -122° 46′ 31″", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        
        formatter.displayOptions = [.suffix]
        XCTAssertEqual("48° 6′ 59″ N, 122° 46′ 31″ W", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("48°6′59″, -122°46′31″", formatter.string(from: CLLocationCoordinate2D.portTownsend))

        formatter.displayOptions = [.suffix, .compact]
        XCTAssertEqual("48°6′59″N, 122°46′31″W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
    }

    // MARK: UTM

    func test_utmString() throws {
        formatter.format = .utm

        XCTAssertEqual("10U 516726m E 5329260m N", formatter.string(from: .portTownsend))
        XCTAssertEqual("19F 607636m E 3794896m N", formatter.string(from: .capeHorn))
        XCTAssertEqual("40M 329980m E 9482760m N", formatter.string(from: .seychelles))
        XCTAssertEqual("29V 611132m E 6883046m N", formatter.string(from: .faroeIslands))
        XCTAssertEqual("60U 668108m E 5694144m N", formatter.string(from: .amchitkaIsland))
        XCTAssertEqual("31N 166021m E 000000m N", formatter.string(from: .nullIsland))

        formatter.displayOptions = []
        XCTAssertEqual("10U 516726m 5329260m", formatter.string(from: .portTownsend))
        
        formatter.displayOptions = [.suffix]
        XCTAssertEqual("10U 516726m E 5329260m N", formatter.string(from: .portTownsend))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("10U 516726m 5329260m", formatter.string(from: .portTownsend))
        
        formatter.displayOptions = [.suffix, .compact]
        XCTAssertEqual("10U 516726mE 5329260mN", formatter.string(from: .portTownsend))
    }

    func test_symbolStyle() throws {
        formatter.symbolStyle = .traditional
        formatter.format = .decimalDegrees

        XCTAssertEqual("55.97917° S, 67.275° W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .simple
        XCTAssertEqual("55.97917° S, 67.275° W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .none
        XCTAssertEqual("55.97917 S, 67.275 W", formatter.string(from: CLLocationCoordinate2D.capeHorn))

        formatter.format = .degreesDecimalMinutes

        formatter.symbolStyle = .traditional
        XCTAssertEqual("55° 58.750′ S, 67° 16.500′ W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .simple
        XCTAssertEqual("55° 58.750' S, 67° 16.500' W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .none
        XCTAssertEqual("55 58.750 S, 67 16.500 W", formatter.string(from: CLLocationCoordinate2D.capeHorn))

        formatter.format = .degreesMinutesSeconds

        formatter.symbolStyle = .traditional
        XCTAssertEqual("55° 58′ 45″ S, 67° 16′ 30″ W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .simple
        XCTAssertEqual("55° 58' 45\" S, 67° 16' 30\" W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        formatter.symbolStyle = .none
        XCTAssertEqual("55 58 45 S, 67 16 30 W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
    }

    // MARK: - Pattern Recognition

    // MARK: - DD

    func test_ddLocation() throws {
        formatter.format = .decimalDegrees
        formatter.symbolStyle = .traditional
        
        XCTAssertEqual(CLLocationCoordinate2D.portTownsend, try formatter.coordinate(from: "48.11638° N, 122.77527° W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55.97917° S, 67.275° W"))
        XCTAssertEqual(CLLocationCoordinate2D.seychelles, try formatter.coordinate(from: "4.67785° S, 55.46718° E"))
        XCTAssertEqual(CLLocationCoordinate2D.faroeIslands, try formatter.coordinate(from: "62.06323° N, 6.87355° W"))
        XCTAssertEqual(CLLocationCoordinate2D.amchitkaIsland,
                       try formatter.coordinate(from: "51.37363° N, 179.41535° E"))
        XCTAssertEqual(CLLocationCoordinate2D.nullIsland, try formatter.coordinate(from: "0.0° N, 0.0° E"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "-55.97917°, -67.275°"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55.97917°S,67.275°W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55.97917 S, 67.275 W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "S 55.97917, W 67.275"))

        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "-55.97917, -67.275"))
        XCTAssertEqual(CLLocationCoordinate2D.faroeIslands, try formatter.coordinate(from: "62.06323, -6.87355"))

        // Google uses a space instead of a comma as its delimiter for whatever reason
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55.97917°S 67.275°W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "-55.97917° -67.275°"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55.97917S 67.275W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "S55.97917 W67.275"))
    }

    // MARK: - DDM

    func test_ddmLocation() throws {
        formatter.format = .degreesDecimalMinutes
        formatter.symbolStyle = .traditional

        XCTAssertEqual(CLLocationCoordinate2D.portTownsend, try formatter.coordinate(from: "48° 06.983′ N, 122° 46.516′ W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55° 58.750′ S, 67° 16.500′ W"))
        XCTAssertEqual(CLLocationCoordinate2D.seychelles, try formatter.coordinate(from: "4° 40.671′ S, 55° 28.031′ E"))
        XCTAssertEqual(CLLocationCoordinate2D.faroeIslands, try formatter.coordinate(from: "62° 03.794′ N, 6° 52.413′ W"))
        XCTAssertEqual(CLLocationCoordinate2D.amchitkaIsland, try formatter.coordinate(from: "51° 22.418′ N, 179° 24.921′ E"))
        XCTAssertEqual(CLLocationCoordinate2D.nullIsland, try formatter.coordinate(from: "0° 00.000′ N, 0° 00.000′ E"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "-55° 58.750′, -67° 16.500′"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55°58.750′S,67°16.500′W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55° 58.750' S, 67° 16.500' W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "S 55° 58.750′ S, W 67° 16.500′"))
        // Google uses a space instead of a comma as its delimiter for whatever reason
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55°58.750′S 67°16.500′W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "-55°58.750′ -67°16.500′"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "55°58.750'S, 67°16.500'W"))
        XCTAssertEqual(CLLocationCoordinate2D.capeHorn, try formatter.coordinate(from: "S55°58.750′S, W67°16.500′"))
    }

    // MARK: - DMS

    func test_dmsLocation() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.symbolStyle = .traditional

        XCTAssertEqualCoordinates(CLLocationCoordinate2D.portTownsend,
                                  try formatter.coordinate(from: "48° 6′ 59″ N, 122° 46′ 31″ W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55° 58′ 45″ S, 67° 16′ 30″ W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.seychelles,
                                  try formatter.coordinate(from: "4° 40′ 40″ S, 55° 28′ 2″ E"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.faroeIslands,
                                  try formatter.coordinate(from: "62° 3′ 48″ N, 6° 52′ 25″ W"),
                                  accuracy: 0.001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.amchitkaIsland,
                                  try formatter.coordinate(from: "51° 22′ 25″ N, 179° 24′ 55″ E"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.nullIsland,
                                  try formatter.coordinate(from: "0° 0′ 0″ N, 0° 0′ 0″ E"))
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "-55° 58′ 45″, -67° 16′ 30″"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55°58′45″S,67°16′30″W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55° 58' 45\" S, 67° 16' 30\" W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "S 55° 58′ 45″, W 67° 16′ 30″"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55°58′45″S, 67°16′30″W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55 58 45 S, 67 16 30 W"),
                                  accuracy: 0.0001)
        // Google uses a space instead of a comma as its delimiter for whatever reason (╯°□°）╯︵ ┻━┻
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55°58′45″S 67°16′30″W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55°58'45\"S 67°16'30\"W"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "S55°58′45″ W67°16′30″"),
                                  accuracy: 0.0001)
        XCTAssertEqualCoordinates(CLLocationCoordinate2D.capeHorn,
                                  try formatter.coordinate(from: "55°58′45″S 67°16′30″W"),
                                  accuracy: 0.0001)
    }

    // MARK: - UTM

    func test_utmLocation() throws {
        formatter.format = .utm

        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U 516726m E 5329260m N"),
                                  accuracy: 0.00001)
        XCTAssertEqualCoordinates(.capeHorn, try formatter.coordinate(from: "19F 607636m E 3794896m N"),
                                  accuracy: 0.00001)
        XCTAssertEqualCoordinates(.seychelles, try formatter.coordinate(from: "40M 329980m E 9482760m N"),
                                  accuracy: 0.00001)
        XCTAssertEqualCoordinates(.faroeIslands, try formatter.coordinate(from: "29V 611132m E 6883046m N"),
                                  accuracy: 0.00001)
        XCTAssertEqualCoordinates(.amchitkaIsland, try formatter.coordinate(from: "60U 668108m E 5694144m N"),
                                  accuracy: 0.00001)
        XCTAssertEqualCoordinates(.nullIsland, try formatter.coordinate(from: "31N 166021m E 000000m N"),
                                  accuracy: 0.00001)

        // Space before suffix is optional
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U 516726mE 5329260mN"),
                                  accuracy: 0.00001)

        // Extra space should be OK
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U   516726m E   5329260m N"),
                                  accuracy: 0.00001)

        // Case insensitive by default
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U 516726M e 5329260m n"),
                                  accuracy: 0.00001)

        // Latitude band is required because without it we cant determine the correct latitude.
        XCTAssertThrowsError(try formatter.coordinate(from: "11 727771mE 5193170mN")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }

    // MARK: - static formatters

    func test_decimalFormatter() throws {
        let formatter = LocationCoordinateFormatter.decimalFormatter

        XCTAssertEqual("48.11638, -122.77527", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("-55.97917, -67.275", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("-4.67785, 55.46718", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62.06323, -6.87355", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51.37363, 179.41535", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0.0, 0.0", formatter.string(from: CLLocationCoordinate2D.nullIsland))
    }

    func test_decimalDegreesFormatter() throws {
        let formatter = LocationCoordinateFormatter.decimalDegreesFormatter

        XCTAssertEqual("48.11638° N, 122.77527° W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55.97917° S, 67.275° W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4.67785° S, 55.46718° E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62.06323° N, 6.87355° W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51.37363° N, 179.41535° E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0.0° N, 0.0° E", formatter.string(from: CLLocationCoordinate2D.nullIsland))
    }

    func test_degreesDecimalMinutesFormatter() throws {
        let formatter = LocationCoordinateFormatter.degreesDecimalMinutesFormatter

        XCTAssertEqual("48° 06.983' N, 122° 46.516' W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55° 58.750' S, 67° 16.500' W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4° 40.671' S, 55° 28.031' E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62° 03.794' N, 6° 52.413' W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51° 22.418' N, 179° 24.921' E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0° 00.000' N, 0° 00.000' E", formatter.string(from: CLLocationCoordinate2D.nullIsland))
    }

    func test_degreesMinutesSecondsFormatter() throws {
        let formatter = LocationCoordinateFormatter.degreesMinutesSecondsFormatter

        XCTAssertEqual("48° 6' 59\" N, 122° 46' 31\" W", formatter.string(from: CLLocationCoordinate2D.portTownsend))
        XCTAssertEqual("55° 58' 45\" S, 67° 16' 30\" W", formatter.string(from: CLLocationCoordinate2D.capeHorn))
        XCTAssertEqual("4° 40' 40\" S, 55° 28' 2\" E", formatter.string(from: CLLocationCoordinate2D.seychelles))
        XCTAssertEqual("62° 3' 48\" N, 6° 52' 25\" W", formatter.string(from: CLLocationCoordinate2D.faroeIslands))
        XCTAssertEqual("51° 22' 25\" N, 179° 24' 55\" E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland))
        XCTAssertEqual("0° 0' 0\" N, 0° 0' 0\" E", formatter.string(from: CLLocationCoordinate2D.nullIsland))
    }
}
