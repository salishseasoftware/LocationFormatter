import Foundation

/// Display options
///
/// Options
/// - suffix: if present the appropriate suffix will be used to represent the basic cardinal direction.
/// - compact: if present, spaces will not be used as long as the SymbolStyle is not `.none`.
public struct DisplayOptions: OptionSet {
    public static let suffix = Self(rawValue: 1 << 0)
    public static let compact = Self(rawValue: 1 << 1)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
}
