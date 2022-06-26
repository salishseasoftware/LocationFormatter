import Foundation

/// Character symbols, or glyphs, used to annotate coordinate components.
enum CoordinateSymbol: Character, CaseIterable {
    /// Degree symbol `°`.
    case degree = "\u{000B0}"
    
    /// Apostrophe symbol `'`.
    ///
    /// The symbol commonly used to annotate minutes on the web and computer applications.
    case apostrophe = "\u{0027}"
    
    /// Quote symbol `"`.
    ///
    /// The symbol commonly used to annotate seconds on the web and computer applications.
    case quote = "\u{0022}"
    
    /// Prime symbol `′` (DiacriticalAcute).
    ///
    /// The symbol commonly used to annotate minutes on printed charts and maps.
    case prime = "\u{02032}"
    
    /// Double prime symbol `″` (DiacriticalDoubleAcute).
    ///
    /// The symbol commonly used to annotate seconds on printed charts and maps.
    case doublePrime = "\u{2033}"
}

extension CoordinateSymbol: CustomStringConvertible {
    var description: String {
        String(describing: rawValue)
    }
}

internal extension String {
    /// Replaces all symbols in string with a space character, and compacts multiple spaces.
    func desymbolized() -> Self {
        
        let symbols = CoordinateSymbol
            .allCases
            .map { String(describing:$0) }
            .joined(separator: "|")
        
        guard let regex = try? NSRegularExpression(pattern: "[\(symbols)]") else {
            return self
        }
        
        return regex
            .stringByReplacingMatches(in: self,
                                      range: NSRange(location: 0, length: self.count),
                                      withTemplate: " ")
            .replacingOccurrences(of: #"\s{2,}"#,
                                  with: " ",
                                  options: .regularExpression)
    }
}
