import Foundation

/// Defines the characters used to annotate coordinate components.
public enum SymbolStyle {
    /// Uses no symbols, components must be space delimited.
    ///
    /// Example:
    /// ```
    /// 48 6 59 N, 122 46 31 W
    /// ```
    case none
    /// Commonly used on the web and computer systems.
    ///
    /// It uses the degree `°` symbol for degrees, the apostrophe `'` for minutes, and the quote `"` symbol for seconds.
    ///
    /// Example:
    /// ```
    /// 48° 6' 59" N, 122° 46' 31" W
    /// ```
    case simple
    /// The typographically correct format commonly used on paper charts and maps.
    ///
    /// It uses the degree `°` symbol for degrees, the prime `′` symbol for minutes, and the double prime `″` symbol for seconds.
    ///
    /// Example:
    /// ```
    /// 48° 6′ 59″ N, 122° 46′ 31″ W
    /// ```
    case traditional

    /// The symbol use to annotate degrees.
    var degrees: String {
        switch self {
        case .none:
            return ""
        case .simple, .traditional:
            return String(describing: CoordinateSymbol.degree)
        }
    }

    /// The symbol use to annotate minutes.
    var minutes: String {
        switch self {
        case .none:
            return ""
        case .simple:
            return String(describing: CoordinateSymbol.apostrophe)
        case .traditional:
            return String(describing: CoordinateSymbol.prime)
        }
    }

    /// The symbol use to annotate seconds.
    var seconds: String {
        switch self {
        case .none:
            return ""
        case .simple:
            return String(describing: CoordinateSymbol.quote)
        case .traditional:
            return String(describing: CoordinateSymbol.doublePrime)
        }
    }
}
