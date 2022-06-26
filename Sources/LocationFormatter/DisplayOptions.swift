import Foundation

/// Display options
public struct DisplayOptions: OptionSet {
    /// Use a suffix to to represent the cardinal direction of the coordinate.
    ///
    /// E.G. "122.77527 W" instead of  "-122.77527"
    public static let suffix = Self(rawValue: 1 << 0)
    
    /// If present, spaces will be omitted.
    ///
    /// E.G. "122.77527W" instead of  "-122.77527"
    ///
    /// - Important: Only applies if the SymbolStyle is not `.none`.
    public static let compact = Self(rawValue: 1 << 1)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
}
