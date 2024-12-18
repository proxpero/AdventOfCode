import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

//let input = """
//47|53
//97|13
//97|61
//97|47
//75|29
//61|13
//75|53
//29|13
//97|29
//53|29
//61|53
//97|53
//61|29
//47|13
//75|47
//97|75
//47|61
//75|61
//47|29
//75|13
//53|13
//
//75,47,61,53,29
//97,61,53,29,13
//75,29,13
//75,97,47,61,53
//61,13,29
//97,13,75,29,47
//"""

// MARK: Parsing

struct Manager {
    struct Rule {
        let before: Int
        let after: Int
    }

    struct Update {
        let pageNumbers: [Int]

        var middle: Int {
            pageNumbers[pageNumbers.count / 2]
        }
    }

    let rules: [Rule]
    let updates: [Update]
    let ordering: [Int: Set<Int>]

    init(
        rules: [Rule],
        updates: [Update]
    ) {
        self.rules = rules
        self.updates = updates
        self.ordering = rules.reduce(into: [:]) { dict, rule in
            dict[rule.before, default: Set<Int>()].insert(rule.after)
        }
    }
}

extension Manager {
    init(input: String) {
        let sections = input.split(separator: "\n\n")
        self.init(
            rules: sections.first!.split(separator: "\n").map(Rule.init),
            updates: sections.last!.split(separator: "\n").map(Update.init)
        )
    }
}

extension Manager.Rule {
    init(line: some StringProtocol) {
        let segments = line.split(separator: "|")
        self.before = Int(segments[0])!
        self.after = Int(segments[1])!
    }
}

extension Manager.Update {
    init(line: some StringProtocol) {
        self.pageNumbers = line.split(separator: ",").map { Int($0)! }
    }
}

let manager = Manager(input: input)

parsing(&timer)

// MARK: Part 1

extension Manager {
    func isOrdered(update: Update) -> Bool {
        update.pageNumbers.combinations(ofCount: 2).allSatisfy {
            ordering[$0[0]]?.contains($0[1]) ?? false
        }
    }
}

let p1 = manager.updates
    .filter { manager.isOrdered(update: $0) }
    .map(\.middle)
    .reduce(0, +)

part1(p1, &timer)

// MARK: Part 2

extension Manager {
    func sorted(_ update: Update) -> Update {
        Update(
            pageNumbers: update.pageNumbers.sorted { p1, p2 in
                ordering[p1]?.contains(p2) ?? false
            }
        )
    }
}

let p2 = manager.updates
    .filter { !manager.isOrdered(update: $0) }
    .map { manager.sorted($0) }
    .map(\.middle)
    .reduce(0, +)

part2(p2, &timer)
