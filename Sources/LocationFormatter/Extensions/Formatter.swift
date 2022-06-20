import Foundation

internal extension Formatter {

    func doubleValue(forName name: String,
                     inResult result: NSTextCheckingResult,
                     for string: String) throws -> Double {
        let val = try value(forName: name, inResult: result, for: string)
        guard let double = Double(val) else { throw ParsingError.notFound(name: name) }
        return double
    }

    func intValue(forName name: String,
                  inResult result: NSTextCheckingResult,
                  for string: String) throws -> Int {
        let val = try value(forName: name, inResult: result, for: string)
        guard let intVal = Int(val) else { throw ParsingError.notFound(name: name) }
        return intVal
    }

    func stringValue(forName name: String,
                     inResult result: NSTextCheckingResult,
                     for string: String) throws -> String {
        return try value(forName: name, inResult: result, for: string)
    }

    func value(forName name: String,
               inResult result: NSTextCheckingResult,
               for string: String) throws -> String {
        let matchedRange = result.range(withName: name)
        guard matchedRange.location != NSNotFound, let range = Range(matchedRange, in: string) else {
            throw ParsingError.notFound(name: name)
        }
        return String(string[range])
    }
}
