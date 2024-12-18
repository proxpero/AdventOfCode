import Algorithms

public struct PointSpace {
    public let width: Int
    public let height: Int
    private let zero = Point(row: 0, col: 0)
}

public extension PointSpace {
    init(square size: Int) {
        self.init(width: size, height: size)
    }
}

public extension PointSpace {
    var minCol: Int { zero.col }
    var maxCol: Int { zero.col + width - 1 }
    var minRow: Int { zero.row }
    var maxRow: Int { zero.row + height - 1 }
    var rowRange: Range<Int> { minRow..<(maxRow + 1) }
    var colRange: Range<Int> { minCol..<(maxCol + 1) }

    var points: [Point] {
        Array(product(rowRange, colRange).map { Point(row: $0.0, col: $0.1) })
    }

    func points(from start: Point, direction: Direction) -> some Sequence<Point> {
        PointSequence(rowRange: rowRange, columnRange: colRange, direction: direction, current: start)
    }

    func nextPoint(origin: Point, direction: Direction, distance: Int = 1) -> Point {
        origin.offset(by: direction.offsets * distance)
    }

    func contains(point: Point) -> Bool {
        (minRow...maxRow) ~= point.row && (minCol...maxCol) ~= point.col
    }

    func validNeighbors(of point: Point, includeDiagonals: Bool = false) -> Set<Point> {
        let directions = Direction.cardinals + (includeDiagonals ? Direction.diagonals : [])
        var result: Set<Point> = []
        for direction in directions {
            let point = nextPoint(origin: point, direction: direction)
            if contains(point: point) {
                result.insert(point)
            }
        }

        return result
    }
}

extension PointSpace {
    struct PointSequence: Sequence, IteratorProtocol {
        let rowRange: Range<Int>
        let columnRange: Range<Int>

        var direction: Direction
        var current: Point

        mutating func next() -> Point? {
            let result = current
            guard rowRange ~= result.row && columnRange ~= result.col else {
                return nil
            }
            let next = current.offset(by: direction.offsets)
            current = next
            return result
        }
    }
}
