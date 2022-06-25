import Foundation

/// Defines the characters used to annotate coordinate components.
public enum SymbolStyle {
    /// Uses no symbols, components must be space delimited.
    case none
    /// Uses the degree `°` character for degrees, apostrophe `'` for minutes, and quote `"` character for seconds.
    case simple
    /// Uses the degree `°` character for degrees, and the prime `′` and double prime `″` characters for minutes and seconds.
    case traditional

    /// Degrees symbol.
    var degrees: String {
        switch self {
        case .none:
            return ""
        case .simple, .traditional:
            return String(describing: CoordinateSymbol.degree)
        }
    }

    /// Minutes symbol.
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

    /// Seconds symbol.
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
