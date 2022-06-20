import Foundation

enum CoordinateSymbol {
    static let degree      = "\u{000B0}" // (°) &deg;
    static let apostrophe  = "\u{0027}"  // (') &apos;
    static let quote       = "\u{0022}"  // (") &quot;
    static let prime       = "\u{02032}" // (′) &prime; DiacriticalAcute
    static let doublePrime = "\u{2033}"  // (″) &Prime; DiacriticalDoubleAcute
    static let singleSpace = "\u{0020}"  // ( ) &#x20;
}

extension String {
    /// Replaces all symbols in string with a space character, and compacts multiple spaces.
    internal func desymbolized() -> Self {
        return self
            .replacingOccurrences(of: CoordinateSymbol.degree, with: CoordinateSymbol.singleSpace)
            .replacingOccurrences(of: CoordinateSymbol.apostrophe, with: CoordinateSymbol.singleSpace)
            .replacingOccurrences(of: CoordinateSymbol.prime, with: CoordinateSymbol.singleSpace)
            .replacingOccurrences(of: CoordinateSymbol.quote, with: CoordinateSymbol.singleSpace)
            .replacingOccurrences(of: CoordinateSymbol.doublePrime, with: CoordinateSymbol.singleSpace)
            .replacingOccurrences(of: #"\s{2,}"#, with: CoordinateSymbol.singleSpace, options: .regularExpression)
    }
}
