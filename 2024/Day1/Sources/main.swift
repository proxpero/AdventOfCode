import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

// MARK: Parsing

let (lhs, rhs) = input
    .split(separator: "\n")
    .map { $0.split(separator: " ") }
    .reduce(into: ([Int](), [Int]())) {
        $0.0.append(Int($1[0])!)
        $0.1.append(Int($1[1])!)
    }

parsing(&timer)

// MARK: Part 1

let p1 = zip(lhs.sorted(), rhs.sorted())
    .map { abs($0.0 - $0.1) }
    .reduce(into: 0) { $0 += $1 }

part1(p1, &timer)

// MARK: Part 2

let counts: [Int: Int] = rhs.reduce(into: [:]) {
    $0[$1, default: 0] += 1
}

let p2 = lhs.reduce(into: 0) {
    $0 += (counts[$1] ?? 0) * $1
}

part2(p2, &timer)
