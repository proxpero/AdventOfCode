import Foundation

extension Date {
    public var millisecondsAgo: Int {
        Int((self.timeIntervalSinceNow * 1000).magnitude)
    }
}
