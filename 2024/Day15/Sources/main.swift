import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

    //input = """
    //##########
    //#..O..O.O#
    //#......O.#
    //#.OO..O.O#
    //#..O@..O.#
    //#O#..O...#
    //#O..O..O.#
    //#.OO.O.OO#
    //#....O...#
    //##########
    //
    //<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    //vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    //><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    //<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    //^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    //^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    //>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    //<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    //^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    //v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    //"""

//input = """
//#######
//#...#.#
//#.....#
//#..OO@#
//#..O..#
//#.....#
//#######
//
//<vv<<^^<<^^
//"""

// MARK: Parsing

let map = input.prefix(while: { "#.O[]@\n".contains($0) })
let directions = input.dropFirst(map.count).compactMap(Direction.init)
parsing(&timer)

// MARK: Part 1

var grid = Grid(rows: map.split(separator: "\n").map { Array($0) })
var robot = grid.first(where: { $0 == "@" })!
for direction in directions {
    var next = grid.nextPoint(origin: robot, direction: direction)

    func handleSpace() {
        grid[robot] = "."
        robot = next
        grid[robot] = "@"
    }

    func handleBox() {
        while grid[next] == "O" {
            next = grid.nextPoint(origin: next, direction: direction)
        }

        switch grid[next] {
        case ".":
            grid[next] = "O"
            grid[robot] = "."
            robot = grid.nextPoint(origin: robot, direction: direction)
            grid[robot] = "@"
        default:
            break
        }
    }

    switch grid[next] {
    case ".":
        handleSpace()
    case "O":
        handleBox()
    default:
        break
    }
}

part1(grid.gps(), &timer)

// MARK: Part 2

func update(result: inout String, element: Character) {
    switch element {
    case "#": result += "##"
    case ".": result += ".."
    case "O": result += "[]"
    case "@": result += "@."
    case "\n": result += "\n"
    default: break
    }
}

grid = Grid(rows: map
    .reduce(into: "", update(result:element:))
    .split(separator: "\n")
    .map { Array($0) }
)

robot = grid.first(where: { $0 == "@" })!

for direction in directions {
    var next = grid.nextPoint(origin: robot, direction: direction)

    func handleSpace() {
        grid[robot] = "."
        robot = next
        grid[robot] = "@"
    }

    func handleHorizontalPush() {
        while "[]".contains(grid[next]) {
            next = grid.nextPoint(origin: next, direction: direction)
        }

        switch grid[next] {
        case ".":
            while next != robot {
                let back = grid.nextPoint(origin: next, direction: direction.inverse)
                grid[next] = grid[back]
                next = back
            }
            grid[robot] = "."
            robot = grid.nextPoint(origin: robot, direction: direction)
            grid[robot] = "@"
        default:
            break
        }
    }

    func handleVerticalPush() {
        var children: Set<Point> = [next]
        var candidates: Set<Point> = [next]
        var visited: Set<Point> = []

        while !candidates.isEmpty {
            func addCandidate(origin: Point, direction: Direction) {
                let child = grid.nextPoint(origin: origin, direction: direction)
                if visited.contains(child) { return }
                candidates.insert(child)
            }

            let child = candidates.removeFirst()
            visited.insert(child)
            switch grid[child] {
            case ".":
                continue
            case "[":
                children.insert(child)
                addCandidate(origin: child, direction: direction)
                addCandidate(origin: child, direction: .right)
            case "]":
                children.insert(child)
                addCandidate(origin: child, direction: direction)
                addCandidate(origin: child, direction: .left)
            default:
                children = []
                candidates = []
                break
            }
        }

        guard !children.isEmpty else {
            return
        }

        let points = children.sorted { p1, p2 in
            let op: (Int, Int) -> Bool = direction == .up ? (<) : (>)
            return op(p1.row, p2.row)
        }

        for point in points {
            let destination = grid.nextPoint(origin: point, direction: direction)
            grid[destination] = grid[point]
            grid[point] = "."
        }

        grid[robot] = "."
        robot = next
        grid[robot] = "@"
    }

    switch (grid[next], direction) {
    case (".", _):
        handleSpace()
    case ("[", .right), ("]", .left):
        handleHorizontalPush()
    case ("[", .up), ("]", .up), ("[", .down), ("]", .down):
        handleVerticalPush()
    default:
        break
    }
}

part2(grid.gps2(), &timer)

// MARK: Additions

extension Direction {
    init?(_ char: Character) {
        switch char {
        case "^": self = .up
        case ">": self = .right
        case "v": self = .down
        case "<": self = .left
        default:
            return nil
        }
    }
}

extension Grid<Character> {
    func gps() -> Int {
        var result = 0
        for point in self.points where self[point] == "O" {
            result += (100 * point.row) + point.col
        }

        return result
    }

    func gps2() -> Int {
        var result = 0
        for point in self.points where self[point] == "[" {
            result += (100 * point.row) + point.col
        }
        
        return result
    }
}
