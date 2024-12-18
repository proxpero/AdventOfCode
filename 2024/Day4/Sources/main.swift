import Algorithms
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

//input = """
//MMMSXXMASM
//MSAMXMSMSA
//AMXSXMAAMM
//MSAMASMSMX
//XMASAMXAMM
//XXAMMXXAMA
//SMSMSASXSS
//SAXAMASAAA
//MAMMMXMMMM
//MXMXAXMASX
//"""

//input = """
//.M.S......
//..A..MSMS.
//.M.S.MAA..
//..A.ASMSM.
//.M.S.M....
//..........
//S.S.S.S.S.
//.A.A.A.A..
//M.M.M.M.M.
//..........
//"""

// MARK: Parsing

let chars = input
    .split(separator: "\n")
    .map { Array($0) }

let grid = Grid(rows: chars)

parsing(&timer)

// MARK: Part 1

var p1 = 0
for point in grid.points where grid[point] == "X" {
    for dir in Direction.allCases  {
        if grid.hasPrefix("XMAS", from: point, direction: dir) {
            p1 += 1
        }
    }
}

part1(p1, &timer)

// MARK: Part 2

var p2 = 0
for point in grid.points where grid[point] == "A" {
    var isFirstPass = false
    for dir in Direction.diagonals.dropLast(2) {
        let a = grid.hasPrefix("MAS", from: point.offset(by: dir.inverse.offsets), direction: dir)
        let b = grid.hasPrefix("MAS", from: point.offset(by: dir.offsets), direction: dir.inverse)
        if a || b {
            if isFirstPass {
                p2 += 1
            } else {
                isFirstPass = true
            }
        }
    }
}

part2(p2, &timer)
