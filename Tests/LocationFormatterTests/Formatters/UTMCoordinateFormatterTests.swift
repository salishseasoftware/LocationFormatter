import CoreLocation
@testable import LocationFormatter
import UTMConversion
import XCTest

class UTMCoordinateFormatterTests: XCTestCase {
    private var formatter: UTMCoordinateFormatter!

    override func setUpWithError() throws {
        formatter = UTMCoordinateFormatter()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        formatter = nil
        try super.tearDownWithError()
    }

    func test_stringFromCoordinate() throws {
        XCTAssertEqual("10U 516726m E 5329260m N", formatter.string(from: .portTownsend))
        XCTAssertEqual("19F 607636m E 3794896m N", formatter.string(from: .capeHorn))
        XCTAssertEqual("40M 329980m E 9482760m N", formatter.string(from: .seychelles))
        XCTAssertEqual("29V 611132m E 6883046m N", formatter.string(from: .faroeIslands))
        XCTAssertEqual("60U 668108m E 5694144m N", formatter.string(from: .amchitkaIsland))
        XCTAssertEqual("31N 166021m E 000000m N", formatter.string(from: .nullIsland))

        // Invalid coordinate
        XCTAssertNil(formatter.string(from: CLLocationCoordinate2D(latitude: 91, longitude: -182)))
    }

    func test_displayOptions() throws {
        formatter.displayOptions = []
        XCTAssertEqual("10U 516726m 5329260m", formatter.string(from: .portTownsend))

        formatter.displayOptions = [.suffix]
        XCTAssertEqual("10U 516726m E 5329260m N", formatter.string(from: .portTownsend))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("10U 516726m 5329260m", formatter.string(from: .portTownsend))

        formatter.displayOptions = [.suffix, .compact]
        XCTAssertEqual("10U 516726mE 5329260mN", formatter.string(from: .portTownsend))
    }

    func test_coordinateFromString() throws {
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

        // Extra space should beOK
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U   516726m E   5329260m N"),
                                  accuracy: 0.00001)

        // Latitude band is required because without it we cant determine the correct latitude.
        XCTAssertThrowsError(try formatter.coordinate(from: "10 516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }

    func test_coordinateFromString_compact() throws {
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U 516726mE 5329260mN"),
                                  accuracy: 0.00001)
    }

    func test_coordinateFromString_noSuffix() throws {
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: "10U 516726m 5329260m"),
                                  accuracy: 0.00001)
    }

    func test_coordinateFromString_zone() throws {
        (1 ... 60).forEach { zone in
            let coordinate = try? formatter.coordinate(from: "\(zone)U 516726m E 5329260m N")
            XCTAssertEqual(UTMGridZone(zone), coordinate?.zone)
        }

        XCTAssertThrowsError(try formatter.coordinate(from: "516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        XCTAssertThrowsError(try formatter.coordinate(from: "61U 516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        XCTAssertThrowsError(try formatter.coordinate(from: "0U 516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        XCTAssertThrowsError(try formatter.coordinate(from: "-10U 516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        XCTAssertThrowsError(try formatter.coordinate(from: "10.1U 516726m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }

    func test_coordinateFromString_latitudeBand() throws {
        XCTAssertEqual(UTMLatitudeBand.U, try formatter.coordinate(from: "10U 516726m E 5329260m N").latitudeBand)

        // all other bands should not match
        try UTMLatitudeBand.allCases.filter { $0 == .U }.forEach { band in
            guard band != .U else { return }

            XCTAssertThrowsError(try formatter.coordinate(from: "10\(band) 516726m E 5329260m N")) { error in
                XCTAssertEqual(error as? ParsingError, .invalidLatitudeBand)
            }
        }

        // all uppercase letters that aren't bands, shouldn't match
        let bandCharacters = UTMLatitudeBand.allCases.map { Character($0.rawValue) }
        let invalidCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".filter { !bandCharacters.contains($0) }

        try invalidCharacters.forEach {
            XCTAssertThrowsError(try formatter.coordinate(from: "10\($0) 516726m E 5329260m N")) { error in
                XCTAssertEqual(error as? ParsingError, .noMatch)
            }
        }
    }

    func test_coordinateFromString_easting() throws {
        XCTAssertEqual(516_726,
                       try formatter.coordinate(from: "10U 516726m E 5329260m N").utmCoordinate().easting,
                       accuracy: 0.00000001)

        // Easting is less than 6 digits
        XCTAssertThrowsError(try formatter.coordinate(from: "10U 51672m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        // Northing is less than 6 digits
        XCTAssertThrowsError(try formatter.coordinate(from: "10U 516726m E 53196m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        // Easting is a decimal
        XCTAssertThrowsError(try formatter.coordinate(from: "10U 516726m.666m E 5329260m N")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }
    }

    func test_coordinateFromString_northing() throws {
        XCTAssertEqual(5_329_260,
                       try formatter.coordinate(from: "10U 516726m E 5329260m N").utmCoordinate().northing,
                       accuracy: 0.00001)
    }

    func test_parsingOptions_caseInsensitive() throws {
        formatter.parsingOptions = []
        let mixedCase = "10u 516726m E 5329260m n"
        
        XCTAssertThrowsError(try formatter.coordinate(from: mixedCase)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        formatter.parsingOptions = [.caseInsensitive]
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: mixedCase), accuracy: 0.00001)
    }

    func test_parsingOptions_trip() throws {
        formatter.parsingOptions = []
        let untrimmed = "   10U 516726m E 5329260m N   "
        
        XCTAssertThrowsError(try formatter.coordinate(from: untrimmed)) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch)
        }

        formatter.parsingOptions = [.trimmed]
        XCTAssertEqualCoordinates(.portTownsend, try formatter.coordinate(from: untrimmed), accuracy: 0.00001)
    }
}
