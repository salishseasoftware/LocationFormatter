import Foundation

/// Defines the characters used to annotate coordinate components.
public enum SymbolStyle {
    /// Uses no symbols, components must be space delimited.
    case none
    /// Uses the degree `°` character for degrees, apostrophe `'` for minutes, and quote `"` character for seconds.
    ///
    /// Commonly used on the web and computer systems.
    case simple
    /// Uses the degree `°` character for degrees, and the prime `′` and double prime `″` characters for minutes and seconds.
    ///
    /// This is the typographically correct format as seen on paper charts and maps.
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
