import Foundation

public func parsing(_ timer: inout Date) {
    print("Parsing | ⏱ \(timer.millisecondsAgo) ms")
    timer = Date()
}

public func part1(_ p1: Any, _ timer: inout Date) {
    print("Part 1: \(String(describing: p1)) | ⏱ \(timer.millisecondsAgo) ms")
    timer = Date()
}

public func part2(_ p2: Any, _ timer: inout Date) {
    print("Part 2: \(String(describing: p2)) | ⏱ \(timer.millisecondsAgo) ms")
    timer = Date()
}
