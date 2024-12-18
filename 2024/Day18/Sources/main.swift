import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)
var size = 70 + 1
var limit = 1024

//input = """
//5,4
//4,2
//4,5
//3,0
//2,1
//6,3
//2,4
//1,5
//0,6
//3,3
//2,6
//5,1
//1,2
//5,5
//2,5
//6,5
//1,4
//0,4
//6,4
//1,1
//6,1
//1,0
//0,5
//1,6
//2,0
//"""

// MARK: Parsing

let bytes = input
    .split(separator: "\n")
    .map(Point.init)
let start: Point = .init(row: 0, col: 0)
let end: Point = .init(row: size - 1, col: size - 1)

parsing(&timer)

// MARK: Part 1

var grid = PointSpace(square: size)
let p1 = grid.bfs(start: start, end: end, obstacles: Set(bytes.prefix(limit)))!
part1(p1, &timer)

// MARK: Part 2

var p2 = start
var obstacles = Set(bytes.prefix(limit))
for byte in bytes.dropFirst(limit) {
    obstacles.insert(byte)
    guard let _ = grid.bfs(start: start, end: end, obstacles: obstacles) else {
        p2 = byte
        break
    }
}

part2(p2.description, &timer)

// MARK: Additions

extension Point {
    init(line: any StringProtocol) {
        let components = line.split(separator: ",")
        self.init(
            row: Int(components[1])!,
            col: Int(components[0])!
        )
    }
}

extension PointSpace {
    func bfs(start: Point, end: Point, obstacles: Set<Point> = []) -> Int? {
        var queue: [Point] = [start]
        var visited: Set<Point> = obstacles
        visited.insert(start)
        var distance: [Point: Int] = [start: 0]
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current == end {
                return distance[current]!
            }

            for neighbor in self.validNeighbors(of: current) where !visited.contains(neighbor) {
                queue.append(neighbor)
                visited.insert(neighbor)
                distance[neighbor] = distance[current]! + 1
            }
        }

        return nil
    }
}
