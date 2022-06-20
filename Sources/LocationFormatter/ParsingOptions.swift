import Foundation

/// Options affecting how a UTMCoordinate is parsed from a string.
///
/// Options
/// - caseInsensitive: determines whether the match is case sensitive or not.
/// - trimmed: if present, any whitespace characters before or after the string will be ignored.
public struct ParsingOptions: OptionSet {
    public static let caseInsensitive = Self(rawValue: 1 << 0)
    public static let trimmed = Self(rawValue: 1 << 1)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
}
