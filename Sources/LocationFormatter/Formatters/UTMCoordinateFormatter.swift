import CoreLocation
import UTMConversion

/**
 A formatter that converts between `CLLocationCoordinate2d` values and their string representations using the Universal Transverse Mercator (UTM) coordinate system.
 
 Instances of UTMCoordinateFormatter create UTM string representations of `CLLocationCoordinate2D` values, and convert UTM textual representations of coordinates into `CLLocationCoordinate2d` values.
 
Formatting a coordinate with the suffix display option:
  
 ```swift
 let formatter = UTMCoordinateFormatter()
 formatter.displayOptions =  [.suffix]
 
 let coordinate = CLLocationCoordinate2D(latitude: 48.11638, longitude: -122.77527)
 formatter.string(from: coordinate)
 // "10U 516726m E 5329260m N"
 ```
 */
public final class UTMCoordinateFormatter: Formatter {
    
    /// The datum to use.
    ///
    /// Default value is WGS84.
    public var datum: UTMDatum = .wgs84
    
    /// Options for displaying UTM coordinates.
    ///
    /// Default options include `DisplayOptions.suffx`.`
    public var displayOptions: DisplayOptions = [.suffix]
    
    /// Options for parsing coordinates strings
    ///
    /// Default options include `ParsingOptions.caseInsensitive`.`
    public var parsingOptions: ParsingOptions = [.caseInsensitive]

    /// Returns a string containing the UTM formatted value of the provided `CLLocationDegrees`.
    public func string(from coordinate: CLLocationCoordinate2D) -> String? {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        let utmCoordinate = coordinate.utmCoordinate(datum: datum)

        var gridZone = "\(utmCoordinate.zone)"
        if let latitudeBand = coordinate.latitudeBand { gridZone += latitudeBand.rawValue }

        guard let easting = utmCoordinate.formattedEasting, let northing = utmCoordinate.formattedNorthing else {
            return nil
        }

        let eastingSuffix = displayOptions.contains(.suffix) ? (isCompact ? "E" : " E") : ""
        let northingSuffix = displayOptions.contains(.suffix) ? (isCompact ? "N" : " N") : ""

        return "\(gridZone) \(easting)\(eastingSuffix) \(northing)\(northingSuffix)"
    }

    /// Returns a `CLLocationCoordinate2D` created by parsing a UTM string.
    public func coordinate(from string: String) throws -> CLLocationCoordinate2D {
        let str = parsingOptions.contains(.trimmed) ? string.trimmingCharacters(in: .whitespacesAndNewlines) : string

        var regexOptions: NSRegularExpression.Options = [.useUnicodeWordBoundaries]
        if parsingOptions.contains(.caseInsensitive) { regexOptions.insert(.caseInsensitive) }

        let regex = try NSRegularExpression(pattern: regexPattern, options: regexOptions)

        let nsRange = NSRange(str.startIndex ..< str.endIndex, in: str)
        guard let match = regex.firstMatch(in: str, options: [.anchored], range: nsRange) else {
            throw ParsingError.noMatch
        }

        let zoneString = try stringValue(forName: "ZONE", inResult: match, for: str)
        guard let zone = UTMGridZone(zoneString), (1 ... 60).contains(zone) else { throw ParsingError.invalidZone }

        var bandString = try stringValue(forName: "BAND", inResult: match, for: str)
        if parsingOptions.contains(.caseInsensitive) { bandString = bandString.uppercased() }
        guard let band = UTMLatitudeBand(rawValue: bandString) else { throw ParsingError.invalidLatitudeBand }

        let easting = try doubleValue(forName: "EASTING", inResult: match, for: str)
        let northing = try doubleValue(forName: "NORTHING", inResult: match, for: str)

        let utmCoord = UTMCoordinate(northing: northing, easting: easting, zone: zone, hemisphere: band.hemisphere)

        let coordinate = utmCoord.coordinate(datum: datum)

        // parsed latitude band should match the derived band, which is based on the actual coordinates
        guard coordinate.latitudeBand == band else { throw ParsingError.invalidLatitudeBand }

        guard CLLocationCoordinate2DIsValid(coordinate) else { throw ParsingError.invalidCoordinate }

        return coordinate
    }

    private var isCompact: Bool {
        displayOptions.contains(.compact)
    }

    // MARK: - Formatter

    override public func string(for obj: Any?) -> String? {
        guard let coordinate = obj as? CLLocationCoordinate2D else { return nil }
        return string(from: coordinate)
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        do {
            let coord = try coordinate(from: string)
            obj?.pointee = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            return obj?.pointee != nil
        } catch let err {
            error?.pointee = err.localizedDescription as NSString
            return false
        }
    }

    let regexPattern: String = #"""
    (?x)
    (?# UTM Zone 1-60)
    (?<ZONE>(0?[1-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9]|60))
    (?# Latitude band)
    (?<BAND>[C|D|E|F|G|H|J|K|L|MN|P|Q|R|S|T|U|V|W|X])
    \h+
    (?# Easting, 6 or more digits)
    (?<EASTING>\d{6,})m\h?E?
    \h+
    (?# Northing, 6 or more digits)
    (?<NORTHING>\d{6,})m\h?N?
    \b
    """#
}

private extension UTMCoordinate {
    var formattedEasting: String? {
        return Self.numberFormatter.string(from: NSNumber(value: easting))
    }

    var formattedNorthing: String? {
        return Self.numberFormatter.string(from: NSNumber(value: northing))
    }

    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .none
        formatter.paddingCharacter = "0"
        formatter.paddingPosition = .beforeSuffix
        formatter.minimumIntegerDigits = 6
        formatter.positiveSuffix = "m"
        return formatter
    }()
}
