import Foundation

internal extension Double {
    /// Rounds a Double to a number of places. Probably not very accurately.
    func roundedTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
