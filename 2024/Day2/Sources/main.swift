import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

// MARK: Parsing

struct Report {
    var levels: [Int]
}

extension Report {
    init(line: Substring) {
        self.levels = line.split(separator: " ").map { Int($0)! }
    }
}

let reports = input.split(separator: "\n")
    .map(Report.init)

parsing(&timer)

// MARK: Part 1

extension Report {
    var isSafe: Bool {
        (levels.isSortedAscending || levels.isSortedDescending)
        && levels.adjacentPairs().allSatisfy { 1...3 ~= abs($0.0 - $0.1) }
    }
}

let p1 = reports.count(where: { $0.isSafe })
part1(p1, &timer)

// MARK: Part 2

extension Report {
    var isSafeUsingDampener: Bool {
        if isSafe { return true }

        for index in levels.indices {
            var temp = self
            temp.levels.remove(at: index)
            if temp.isSafe { return true }
        }

        return false
    }
}

let p2 = reports.count(where: { $0.isSafeUsingDampener })
part2(p2, &timer)

// MARK: Additions

extension Collection where Element: Comparable {
    var isSortedAscending: Bool {
        adjacentPairs().allSatisfy { $0 < $1 }
    }

    var isSortedDescending: Bool {
        adjacentPairs().allSatisfy { $0 > $1 }
    }
}
