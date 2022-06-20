import CoreLocation
@testable import LocationFormatter
import XCTest

class LocationDegreesFormatterTests: XCTestCase {
    private var formatter: LocationDegreesFormatter!

    override func setUpWithError() throws {
        formatter = LocationDegreesFormatter()
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
        formatter.orientation = .none

        XCTAssertEqual("-55.97917°", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67.275°", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("-4.67785°", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55.46718°", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62.06323°", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("-6.87355°", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51.37363°", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179.41535°", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0.0°", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0.0°", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_ddLatitudeString() throws {
        formatter.format = .decimalDegrees
        formatter.orientation = .latitude

        XCTAssertEqual("55.97917° S", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67.275° S", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4.67785° S", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55.46718° N", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62.06323° N", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6.87355° S", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51.37363° N", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertNil(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0.0° N", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0.0° N", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_ddLongitudeString() throws {
        formatter.format = .decimalDegrees
        formatter.orientation = .longitude

        XCTAssertEqual("55.97917° W", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67.275° W", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4.67785° W", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55.46718° E", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62.06323° E", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6.87355° W", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51.37363° E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179.41535° E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0.0° E", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0.0° E", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    // MARK: DDM

    func test_ddmString() throws {
        formatter.format = .degreesDecimalMinutes
        formatter.orientation = .none
        formatter.symbolStyle = .traditional

        XCTAssertEqual("-55° 58.750′", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16.500′", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("-4° 40.671′", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28.031′", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 03.794′", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("-6° 52.413′", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22.418′", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179° 24.921′", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 00.000′", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 00.000′", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_ddmLatitudeString() throws {
        formatter.format = .degreesDecimalMinutes
        formatter.orientation = .latitude
        formatter.symbolStyle = .traditional

        XCTAssertEqual("55° 58.750′ S", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67° 16.500′ S", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4° 40.671′ S", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28.031′ N", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 03.794′ N", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6° 52.413′ S", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22.418′ N", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertNil(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 00.000′ N", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 00.000′ N", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_ddmLongitudeString() throws {
        formatter.format = .degreesDecimalMinutes
        formatter.orientation = .longitude
        formatter.symbolStyle = .traditional

        XCTAssertEqual("55° 58.750′ W", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67° 16.500′ W", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4° 40.671′ W", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28.031′ E", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 03.794′ E", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6° 52.413′ W", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22.418′ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179° 24.921′ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 00.000′ E", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 00.000′ E", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    // MARK: DMS

    func test_dmsString() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.orientation = .none
        formatter.symbolStyle = .traditional

        XCTAssertEqual("-55° 58′ 45″", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16′ 30″", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("-4° 40′ 40″", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28′ 2″", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 3′ 48″", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("-6° 52′ 25″", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22′ 25″", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179° 24′ 55″", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 0′ 0″", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 0′ 0″", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_dmsLatitudeString() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.orientation = .latitude
        formatter.symbolStyle = .traditional

        XCTAssertEqual("55° 58′ 45″ S", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67° 16′ 30″ S", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4° 40′ 40″ S", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28′ 2″ N", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 3′ 48″ N", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6° 52′ 25″ S", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22′ 25″ N", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertNil(formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 0′ 0″ N", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 0′ 0″ N", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    func test_dmsLongitudeString() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.orientation = .longitude
        formatter.symbolStyle = .traditional

        XCTAssertEqual("55° 58′ 45″ W", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("67° 16′ 30″ W", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        XCTAssertEqual("4° 40′ 40″ W", formatter.string(from: CLLocationCoordinate2D.seychelles.latitude))
        XCTAssertEqual("55° 28′ 2″ E", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        XCTAssertEqual("62° 3′ 48″ E", formatter.string(from: CLLocationCoordinate2D.faroeIslands.latitude))
        XCTAssertEqual("6° 52′ 25″ W", formatter.string(from: CLLocationCoordinate2D.faroeIslands.longitude))

        XCTAssertEqual("51° 22′ 25″ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.latitude))
        XCTAssertEqual("179° 24′ 55″ E", formatter.string(from: CLLocationCoordinate2D.amchitkaIsland.longitude))

        XCTAssertEqual("0° 0′ 0″ E", formatter.string(from: CLLocationCoordinate2D.nullIsland.latitude))
        XCTAssertEqual("0° 0′ 0″ E", formatter.string(from: CLLocationCoordinate2D.nullIsland.longitude))
    }

    // MARK: SymbolStyle

    func test_symbolStyle() throws {
        formatter.format = .decimalDegrees

        formatter.symbolStyle = .traditional // default
        XCTAssertEqual("-55.97917°", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67.275°", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .simple
        XCTAssertEqual("-55.97917°", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67.275°", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .none
        XCTAssertEqual("-55.97917", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67.275", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.format = .degreesDecimalMinutes

        formatter.symbolStyle = .traditional // default
        XCTAssertEqual("-55° 58.750′", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16.500′", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .simple
        XCTAssertEqual("-55° 58.750\'", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16.500\'", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .none
        XCTAssertEqual("-55 58.750", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67 16.500", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.format = .degreesMinutesSeconds

        formatter.symbolStyle = .traditional
        XCTAssertEqual("-55° 58′ 45″", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16′ 30″", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .simple
        XCTAssertEqual("-55° 58' 45\"", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67° 16' 30\"", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))

        formatter.symbolStyle = .none
        XCTAssertEqual("-55 58 45", formatter.string(from: CLLocationCoordinate2D.capeHorn.latitude))
        XCTAssertEqual("-67 16 30", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
    }

    // MARK: Display Options

    func test_displayOptions() throws {
        formatter.format = .degreesMinutesSeconds
        formatter.symbolStyle = .traditional

        formatter.displayOptions = []
        // Default options
        XCTAssertEqual("-67° 16′ 30″", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55° 28′ 2″", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        formatter.displayOptions = [.suffix]
        // orientation is .none by default, so no suffix can be determined, suffix option should be ignored
        XCTAssertEqual("-67° 16′ 30″", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55° 28′ 2″", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        formatter.orientation = .longitude
        XCTAssertEqual("67° 16′ 30″ W", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55° 28′ 2″ E", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        formatter.displayOptions = [.compact]
        XCTAssertEqual("-67°16′30″", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55°28′2″", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        formatter.displayOptions = [.compact]
        formatter.symbolStyle = .none
        // symbol style .none, so compact option should be ignored
        XCTAssertEqual("-67 16 30", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55 28 2", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))

        formatter.displayOptions = [.suffix, .compact]
        formatter.symbolStyle = .traditional
        XCTAssertEqual("67°16′30″W", formatter.string(from: CLLocationCoordinate2D.capeHorn.longitude))
        XCTAssertEqual("55°28′2″E", formatter.string(from: CLLocationCoordinate2D.seychelles.longitude))
    }

    // MARK: - Pattern Recognition

    // MARK: DD

    func test_locationDegreesDD() {
        formatter.format = .decimalDegrees
        formatter.orientation = .none
        let expected = CLLocationCoordinate2D.capeHorn.latitude

        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55.97917° N"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917° S"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55.97917° E"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917° W"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917°S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917 S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55.97917°"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55.97917"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917S"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55.97917° South"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55.97917000000000000123"))

        // direction
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S 55.97917°"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S55.97917°"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "s 55.97917°"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55.97917° s"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S 55.97917° s"))

        // Invalid Degrees

        XCTAssertThrowsError(try formatter.locationDegrees(from: "180.0001° S")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-180.0001")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        // No match

        XCTAssertThrowsError(try formatter.locationDegrees(from: "55° 58.750′ S")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DDM' format to not match 'DD' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-55 58 45")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DMS' format to not match 'DD' format.")
        }

        // Conflict

        XCTAssertThrowsError(try formatter.locationDegrees(from: "S 55.97917° N")) { error in
            XCTAssertEqual(error as? ParsingError, .conflict)
        }
    }

    // MARK: DDM

    func test_locationDegreesDDM() {
        formatter.format = .degreesDecimalMinutes
        formatter.orientation = .none
        let expected = CLLocationCoordinate2D.capeHorn.latitude

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55° 58.750′ S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55° 58.750' S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55°58.750′S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55°58.750′"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55 58.750′ S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55 58.750 S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55 58.750"))

        // direction suffix
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58.750′"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "-55° 58.750′ N"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55° 58.750′ N"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55° 58.750′ E"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55° 58.750′ W"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55° 58.750′ South"))

        // direction prefix
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "N -55° 58.750′"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "N 55° 58.750′"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "E 55° 58.750′"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "W 55° 58.750′"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "s 55° 58.750′"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S55° 58.750′"))

        // No match

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-55.97917")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DD' format to not match 'DDM' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-55 58 45")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DMS' format to not match 'DDM' format.")
        }

        // Invalid minutes

        XCTAssertThrowsError(try formatter.locationDegrees(from: "47° 60.1′ N")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeMinutes)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "47° 60.001′ S")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeMinutes)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "20° 60.001′ E")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeMinutes)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "120° 60.001′ W")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeMinutes)
        }

        // Invalid degrees

        XCTAssertThrowsError(try formatter.locationDegrees(from: "180° 00.01′ E")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "180° 00.001′ W")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-180° 00.01′")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "90° 01.001′ N")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "90° 01.001′ S")) { error in
            XCTAssertEqual(error as? ParsingError, .invalidRangeDegrees)
        }
    }

    // MARK: DMS

    func test_locationDegreesDMS() {
        formatter.format = .degreesMinutesSeconds
        let expected = CLLocationCoordinate2D.capeHorn.latitude

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58′ 45.411″"), accuracy: 0.001)

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58′ 45\""))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58' 45\""))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58' 45\""))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55 58 45"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55°58′45\""))

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55° 58′ 45″ S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55° 58′ 45″ s"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "55°58′45″S"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55°58′45″"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "55° 58′ 45″ South"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58′ 45″ S"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "-55° 58′ 45″ N"),
                       "Expected conflicting suffix to be ignored.")
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "-55° 58′ 45″ W"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "-55° 58′ 45″ E"))

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S 55° 58′ 45″"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "s 55° 58′ 45″"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S55°58′45″"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S -55° 58′ 45″"))
        XCTAssertEqual(expected, try formatter.locationDegrees(from: "W -55° 58′ 45″"))
        XCTAssertEqual(-expected, try formatter.locationDegrees(from: "E -55° 58′ 45″"))

        XCTAssertNil(try? formatter.locationDegrees(from: "180° 00′ 00.01″ S"))

        XCTAssertEqual(expected, try formatter.locationDegrees(from: "S 55° 58′ 45″ S"))

        // No match

        XCTAssertThrowsError(try formatter.locationDegrees(from: "55.97917° S")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DD' format to not match 'DMS' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-55.97917")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DD' format to not match 'DMS' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "55° 58.750′ S")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DDM' format to not match 'DMS' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "-55 58.750")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected 'DDM' format to not match 'DMS' format.")
        }

        XCTAssertThrowsError(try formatter.locationDegrees(from: "South 55° 58′ 45″")) { error in
            XCTAssertEqual(error as? ParsingError, .noMatch,
                           "Expected prefix to not match.")
        }

        // Conflicts
        XCTAssertThrowsError(try formatter.locationDegrees(from: "w 55° 58′ 45″ S")) { error in
            XCTAssertEqual(error as? ParsingError, .conflict,
                           "Expected conflicting prefix and suffix.")
        }
    }
}
