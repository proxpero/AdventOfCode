import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

//input = """
//....#.....
//.........#
//..........
//..#.......
//.......#..
//..........
//.#..^.....
//........#.
//#.........
//......#...
//"""

// MARK: Parsing

extension Direction {
    init(char: Character) {
        switch char {
        case "^": self = .up
        case ">": self = .right
        case "v": self = .down
        case "<": self = .left
        default:
            fatalError("Invalid direction: \(char)")
        }
    }
}

struct State: Hashable {
    var position: Point
    var direction: Direction
}

let chars = input
    .split(separator: "\n")
    .map { Array($0) }
var grid = Grid(rows: chars)
let origin = grid.points.first { "^><v".contains(grid[$0]) }!
let direction = Direction(char: grid[origin])

parsing(&timer)

// MARK: Part 1

extension Grid<Character> {
    func visited(origin: Point, direction: Direction) -> Set<Point>? {
        var state: State = .init(position: origin, direction: direction)
        var states: Set<State> = []
        var visited: Set<Point> = []

        while self.contains(point: state.position) {
            let (isNotLoop, _) = states.insert(state)
            guard isNotLoop else { return nil }

            visited.insert(state.position)
            let next = self.nextPoint(origin: state.position, direction: state.direction)
            guard self.contains(point: next) else {
                break
            }

            if self[next] == "#" {
                state.direction.rotating(.clockwise, by: 2)
            } else {
                state.position = next
            }
        }

        return visited
    }
}

let visited = grid.visited(origin: origin, direction: direction)!
let p1 = visited.count
part1(p1, &timer)

// MARK: Part 2

extension Grid<Character> {
    mutating func loops(origin: Point, direction: Direction, visited: Set<Point>) -> Int {
        var result: Int = 0
        for point in visited.subtracting([origin]) {
            self[point] = "#"
            if self.visited(origin: origin, direction: direction) == nil { result += 1 }
            self[point] = "."
        }

        return result
    }
}

let p2 = grid.loops(origin: origin, direction: direction, visited: visited)
part2(p2, &timer)
