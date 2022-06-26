import Foundation

/// Options affecting how a coordinate is parsed from a string.
public struct ParsingOptions: OptionSet {
    /// Disregard case when matching strings.
    public static let caseInsensitive = Self(rawValue: 1 << 0)
    /// Ignore whitespace at the beginning and end of the string.
    public static let trimmed = Self(rawValue: 1 << 1)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
}
