import Algorithms
import Utilities
import Foundation
import RegexBuilder

var timer = Date()
var input = try load(from: .module)

// MARK: Parsing
parsing(&timer)

// MARK: Part 1

let p1 = input
    .matches(of: /mul\((\d{1,3}),(\d{1,3})\)/)
    .map { Int($0.output.1)! * Int($0.output.2)! }
    .reduce(0, +)

part1(p1, &timer)

// MARK: Part 2

var enabled = true
var p2 = 0

let regex2 = Regex {
    ChoiceOf {
        /(mul)\((\d{1,3}),(\d{1,3})\)/
        /(do)\(\)/
        /(don't)\(\)/
    }
}

for match in input.matches(of: regex2) {
    switch match.output.1 ?? match.output.4 ?? match.output.5 {
    case "mul":
        guard enabled else { continue }
        p2 += Int(match.output.2!)! * Int(match.output.3!)!
    case "do":
        enabled = true
    case "don't":
        enabled = false
    default:
        continue
    }
}

part2(p2, &timer)
