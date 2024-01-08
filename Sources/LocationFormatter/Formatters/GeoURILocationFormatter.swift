import Foundation
import CoreLocation

/** A formatter that converts between `CLLocation` objects and their `GeoURI` representations.

 [RFC5870](https://datatracker.ietf.org/doc/html/rfc5870) specifies a Uniform Resource Identifier (URI)
 for geographic locations using the 'geo' scheme name.  A 'geo' URI identifies a physical location
 in a two- or three-dimensional coordinate reference system in a compact, simple, human-readable,
 and protocol-independent way.
 
  - Note: The default coordinate reference system used is the [World Geodetic System 1984](https://earth-info.nga.mil/?dir=wgs84&action=wgs84) (WGS-84).
*/
public final class GeoURILocationFormatter: Formatter {
    
    /// Options for parsing coordinates strings.
    ///
    /// Default options include `ParsingOptions.caseInsensitive`.
    public var parsingOptions: ParsingOptions = [.caseInsensitive]
    
    /// Options for converting between `CLLocation` objects and GeoURI strings.
    public var options: GeoURIFormatOptions = [.normalizeLongitude]
    
    /// Returns a `GeoURI` string representation of a `CLLocation` object.
    public func string(fromLocation location: CLLocation) -> String? {
        return string(for: location)
    }
    
    /// Returns a `CLLocation` object created by parsing a `GeoURI` string.
    ///
    /// A ``ParsingError`` is thrown if the string is not a valid `GeoURI`.
    public func location(from string: String) throws -> CLLocation {
        
        var geoURI = parsingOptions.contains(.trimmed) ? string.trimmingCharacters(in: .whitespacesAndNewlines) : string
        
        if parsingOptions.contains(.caseInsensitive) {
            geoURI = geoURI.lowercased()
        }
                
        var components = geoURI.components(separatedBy: ";")
        
        let baseUri = components.removeFirst()
        
        let prefix = "geo:"
        
        guard baseUri.hasPrefix(prefix) else {
            throw ParsingError.noMatch
        }
        
        let pathComponents = baseUri
            .dropFirst(prefix.count)
            .components(separatedBy: ",")
        
        guard (2...3).contains(pathComponents.count) else {
            throw ParsingError.noMatch
        }
        
        guard pathComponents.indices.contains(0), let latitude = Double(pathComponents[0]) else {
            throw ParsingError.noMatch
        }
        
        guard pathComponents.indices.contains(1), let longitude = Double(pathComponents[1]) else {
            throw ParsingError.noMatch
        }
        
        var altitude: Double? = nil
        if pathComponents.indices.contains(2) {
            guard let altVal = Double(pathComponents[2]) else {
                throw ParsingError.noMatch
            }
            altitude = altVal
        }

        var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if options.contains(.normalizeLongitude) {
            coordinate = coordinate.normalized()
        }
        
        guard CLLocationCoordinate2DIsValid(coordinate) else { throw ParsingError.invalidCoordinate }
                
        let queryComponents = components
            .map { $0.lowercased() }
            .map { $0.components(separatedBy: "=") }
            .filter { $0.count == 2 }
            .map { ($0[0], $0[1]) }
        
        let params = Dictionary(queryComponents, uniquingKeysWith: { (first, _) in first })
        
        if let crs = params["crs"] {
            guard crs.caseInsensitiveCompare("wgs84") == .orderedSame else {
                throw ParsingError.unsupportedCoordinateReferenceSystem(crs: crs)
            }
        }
        
        var uncertainty: Double = .zero
        if let uval = params["u"], let doubleUval = Double(uval) {
            uncertainty = doubleUval
        }

        return CLLocation(
            coordinate: coordinate,
            altitude: altitude ?? .zero,
            horizontalAccuracy: uncertainty,
            verticalAccuracy: altitude != nil ? uncertainty : .zero,
            timestamp: Date()
        )
    }
    
    // MARK: - Formatter

    override public func string(for obj: Any?) -> String? {
        
        guard let location = obj as? CLLocation else { return nil }
        
        let coordinate = options.contains(.normalizeLongitude) ? location.coordinate.normalized() : location.coordinate
        
        guard CLLocationCoordinate2DIsValid(coordinate), location.horizontalAccuracy >= .zero else {
            return nil
        }
        
        var pathComponents = [location.coordinate.latitude, location.coordinate.longitude]
        
        if location.verticalAccuracy > .zero {
            pathComponents.append(location.altitude)
        }
        
        let path = pathComponents
            .compactMap { Self.numberFormatter.string(from: NSDecimalNumber(value: $0)) }
            .joined(separator: ",")
        
        var desc =  "geo:\(path)"
        
        if options.contains(.includeCRS) {
            desc.append(";crs=wgs84")
        }
        
        if let uncertainty = location.uncertainty, let uVal = Self.numberFormatter.string(from: NSDecimalNumber(value: uncertainty)) {
            desc.append(";u=\(uVal)")
        }
        
        return desc
    }
    
    override public func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        do {
            let location = try location(from: string)
            obj?.pointee = location
            return obj?.pointee != nil
        } catch let err {
            error?.pointee = err.localizedDescription as NSString
            return false
        }
    }
    
    // MARK: - Internal
    
    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 11
        formatter.decimalSeparator = "."
        formatter.positivePrefix = ""
        formatter.negativePrefix = "-"
        formatter.hasThousandSeparators = false
        formatter.localizesFormat = false
        return formatter
    }()
}

