import Algorithms
import Collections
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

//input = """
//###############
//#.......#....E#
//#.#.###.#.###.#
//#.....#.#...#.#
//#.###.#####.#.#
//#.#.#.......#.#
//#.#.#####.###.#
//#...........#.#
//###.#.#####.#.#
//#...#.....#.#.#
//#.#.#.###.#.#.#
//#.....#...#.#.#
//#.###.#.#.#.#.#
//#S..#.....#...#
//###############
//"""

//input = """
//#################
//#...#...#...#..E#
//#.#.#.#.#.#.#.#.#
//#.#.#.#...#...#.#
//#.#.#.#.###.#.#.#
//#...#.#.#.....#.#
//#.#.#.#.#.#####.#
//#.#...#.#.#.....#
//#.#.#####.#.###.#
//#.#.#.......#...#
//#.#.###.#####.###
//#.#.#...#.....#.#
//#.#.#.#####.###.#
//#.#.#.........#.#
//#.#.#.#########.#
//#S#.............#
//#################
//"""

// MARK: Parsing

let grid = Grid(rows: input.split(separator: "\n").map(Array.init))
let start = grid.first(where: { $0 == "S" })!
let end = grid.first(where: { $0 == "E" })!

struct Location: Hashable {
    var point: Point
    var direction: Direction
}

struct State: Comparable, Hashable {
    var location: Location
    var score: Int
    var path: Path

    init (point: Point, direction: Direction, score: Int, path: Path = []) {
        self.location = .init(point: point, direction: direction)
        self.score = score
        self.path = path
    }

    func rotated(by direction: Direction.ClockDirection) -> State {
        var temp = self
        temp.location.direction = temp.location.direction.rotated(direction, by: 2)
        temp.score += 1000
        return temp
    }

    static func < (lhs: State, rhs: State) -> Bool {
        lhs.score < rhs.score
    }
}

parsing(&timer)

// MARK: Part 1

extension Grid<Character> {
    func minimumScore(origin start: Point, destination end: Point) -> Int {
        var heap: Heap<State> = [.init(point: start, direction: .right, score: 0)]
        var visited: [Location: Int] = [:]
        while let current = heap.popMin() {
            if let score = visited[current.location], score < current.score { continue }
            visited[current.location] = current.score

            if current.location.point == end {
                return current.score
            }

            let next = self.nextPoint(origin: current.location.point, direction: current.location.direction)
            if self[next] != "#" {
                heap.insert(.init(point: next, direction: current.location.direction, score: current.score + 1))
            }

            heap.insert(current.rotated(by: .clockwise))
            heap.insert(current.rotated(by: .counterClockwise))
        }

        return 0
    }
}

let p1 = grid.minimumScore(origin: start, destination: end)
part1(p1, &timer)

// MARK: Part 2

typealias Path = [Point]

extension Grid<Character> {
    struct Result {
        let score: Int
        var paths: [Path]
    }

    func bestPaths(origin start: Point, destination end: Point) -> [Path] {
        let initialState: State = .init(point: start, direction: .right, score: 0, path: [start])
        var heap: Heap<State> = [initialState]
        var visited: [Location: Result] = [:]
        var minimum: Result = .init(score: Int.max, paths: [])

        while let current = heap.popMin() {
            if let result = visited[current.location] {
                if current.score == result.score {
                    visited[current.location] = .init(score: result.score, paths: result.paths + [current.path])
                } else if current.score < result.score {
                    visited[current.location] = .init(score: current.score, paths: [current.path])
                } else {
                    continue
                }
            } else {
                visited[current.location] = .init(score: current.score, paths: [current.path])
            }

            if current.location.point == end {
                if minimum.score > current.score {
                    minimum = .init(score: current.score, paths: [current.path])
                } else if current.score == minimum.score {
                    minimum.paths.append(current.path)
                }
            }

            let next = self.nextPoint(origin: current.location.point, direction: current.location.direction)
            if self[next] != "#" {
                let state = State(
                    point: next,
                    direction: current.location.direction,
                    score: current.score + 1,
                    path: current.path + [next]
                )
                heap.insert(state)
            }

            heap.insert(current.rotated(by: .clockwise))
            heap.insert(current.rotated(by: .counterClockwise))
        }

        return minimum.paths
    }
}

let p2 = grid.bestPaths(origin: start, destination: end)
    .reduce(into: Set<Point>()) { $0.formUnion($1) }
    .count

part2(p2, &timer)
