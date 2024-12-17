import ArgumentParser
import Foundation
import ShellOut
import ToolKit

@main
struct AOC: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Tools for Advent of Code",
        subcommands: [Auth.self, Init.self, LoadInput.self, Rebuild.self, Run.self, Open.self]
    )
}

struct Auth: ParsableCommand {
    @Argument
    var session: String

    func run() throws {
        let config = try Configuration.load()
        try config.setSession(session)
        try config.setSharedSessionCookie()
    }
}

struct Init: ParsableCommand {
    @Option(name: [.long, .short])
    var year: Int?

    @Option(name: [.long, .short])
    var day: Int?

    @Flag(
        name: [.long, .short],
        help: "Quit and reopen Xcode? (default: false"
    )
    var quit: Bool = false

    func run() throws {
        var path: String?
        switch (year, day) {
        case (let .some(y), let .some(d)):
            let day = try create(year: y, day: d)
            path = try day.packageFile.path
        case (let .some(y), .none):
            let year = try create(year: y, days: 1...25)
            path = try year.workspace.path
        case (.none, let .some(d)):
            let day = try create(day: d)
            path = try day.packageFile.path
        case (.none, .none):
            let day = try create()
            path = try day.packageFile.path
        }

        if quit, let path {
            try shellOut(to: "osascript -e 'quit app \"Xcode\"'")
            try shellOut(to: "sleep 0.1")
            try shellOut(to: "xed \(path)")
        }
    }

    private func create(year: Int, day: Int) throws -> Day {
        print("Creating Day\(day), \(year)...")
        let day = Day(year: year, day: day)
        try day.create()

        let year = Year(year: year)
        try year.createWorkspace()
        try year.createPlaygroundIfNecessary()

        return day
    }

    private func create(year: Int, days: ClosedRange<Int>) throws -> Year {
        let year = Year(year: year)
        for day in days {
            let day = Day(year: year.year, day: day)
            try day.create()
            sleep(1)
        }

        try year.createWorkspace()
        try year.createPlaygroundIfNecessary()

        return year
    }

    private func create(day: Int) throws -> Day {
        try create(year: defaultYear, day: day)
    }

    private func create() throws -> Day {
        try create(day: defaultDay)
    }

    private var defaultYear: Int {
        let date = Date()
        var currentYear = Calendar.current.component(.year, from: date)

        if Calendar.current.component(.month, from: date) < 12 {
            currentYear -= 1
        }

        return currentYear
    }

    private var defaultDay: Int {
        Calendar.current.component(.day, from: Date())
    }
}

struct LoadInput: ParsableCommand {
    @Argument var year: Int
    @Argument var day: Int

    func run() throws {
        try Day(year: year, day: day).udpateInputInPlace()
    }
}

struct Rebuild: ParsableCommand {
    func run() throws {
        try shellOut(to: "swift build -c release", at: "./CoreAOC")
        try shellOut(to: .copyFile(from: "./CoreAOC/.build/release/aoc", to: "."))
    }
}

struct Run: ParsableCommand {
    @Argument var year: Int
    @Argument var day: Int

    func run() throws {
        print("Running \(year) | Day \(day)\n")
        try shellOut(
            to: "swift run -c release",
            at: "./\(year)/Day\(day)",
            outputHandle: .standardOutput
        )
        print("\n")
    }
}

struct Open: ParsableCommand {
    @Argument var year: Int
    @Argument var day: Int
    
    func run() throws {
        print("Opening \(year) | Day \(day)...")
        try shellOut(to: "osascript -e 'quit app \"Xcode\"'")
        try shellOut(to: "sleep 0.1")
        try shellOut(to: "xed ./\(year)/Day\(day)/Package.swift")
    }
}
