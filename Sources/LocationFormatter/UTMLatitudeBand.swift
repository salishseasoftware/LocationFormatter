import CoreLocation
import UTMConversion

/**
 Latitude bands are not a part of UTM, but rather a part of the military grid reference system (MGRS). They
are however sometimes used.

 Each zone is segmented into 20 latitude bands. Each latitude band is 8 degrees high, and is lettered starting
 from "C" at 80°S, increasing up the English alphabet until "X", omitting the letters "I" and "O" (because of
 their similarity to the numerals one and zero). The last latitude band, "X", is extended an extra 4 degrees,
 so it ends at 84°N latitude, thus covering the northernmost land on Earth.

 The combination of a zone and a latitude band defines a grid zone. The zone is always written first,
 followed by the latitude band. For example, a position in Toronto, Ontario, Canada, would find itself in
 zone 17 and latitude band "T", thus the full grid zone reference is "17T".
 */
enum UTMLatitudeBand: String, CaseIterable, Comparable {
    case C, D, E, F, G, H, J, K, L, M, N, P, Q, R, S, T, U, V, W, X

    /// The hemisphere the latitude band is in.
    var hemisphere: UTMHemisphere {
        self < .N ? .southern : .northern
    }

    init?(coordinate: CLLocationCoordinate2D) {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        switch coordinate.latitude {
        // Southern hemisphere
        case -80 ..< -72: self = .C
        case -72 ..< -64: self = .D
        case -64 ..< -56: self = .E
        case -56 ..< -48: self = .F
        case -48 ..< -40: self = .G
        case -40 ..< -32: self = .H
        case -32 ..< -24: self = .J
        case -24 ..< -16: self = .K
        case -16 ..< -8: self = .L
        case -8 ..< 0: self = .M

        // Northern hemisphere
        case 0 ..< 8: self = .N
        case 8 ..< 16: self = .P
        case 16 ..< 24: self = .Q
        case 24 ..< 32: self = .R
        case 32 ..< 40: self = .S
        case 40 ..< 48: self = .T
        case 48 ..< 56: self = .U
        case 56 ..< 64: self = .V
        case 64 ..< 72: self = .W
        case 72 ... 84: self = .X // NOTE: 'X' is 12° not 8°

        default:
            return nil
        }
    }

    static func < (lhs: UTMLatitudeBand, rhs: UTMLatitudeBand) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension CLLocationCoordinate2D {
    /// The latitude band of the coordinate.
    var latitudeBand: UTMLatitudeBand? {
        return UTMLatitudeBand(coordinate: self)
    }
}
