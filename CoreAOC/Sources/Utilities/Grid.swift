import Algorithms

public struct Grid<Element> {
    public let width: Int
    public let height: Int
    public var elements: [[Element]]
    private let zero = Point(row: 0, col: 0)

    public init(rows: [[Element]]) {
        self.width = rows.first?.count ?? 0
        self.height = rows.count
        self.elements = rows
    }
}

public extension Grid {
    var minCol: Int { zero.col }
    var maxCol: Int { zero.col + width - 1 }
    var minRow: Int { zero.row }
    var maxRow: Int { zero.row + height - 1 }
    var rowRange: Range<Int> { minRow..<(maxRow + 1) }
    var colRange: Range<Int> { minCol..<(maxCol + 1) }

    subscript(row row: Int, column col: Int) -> Element {
        get { elements[row - minRow][col - minCol] }
        set { elements[row - minRow][col - minCol] = newValue }
    }

    subscript(column col: Int) -> [Element] {
        elements.map { $0[col - minCol] }
    }

    subscript(row row: Int) -> [Element] {
        elements[row - minRow]
    }

    subscript(_ point: Point) -> Element {
        get { self[row: point.row, column: point.col] }
        set { self[row: point.row, column: point.col] = newValue }
    }

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
}

extension Grid {
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

public extension Grid where Element: Equatable {
    func hasPrefix(_ sequence: some Sequence<Element>, from origin: Point, direction: Direction) -> Bool {
        guard self.contains(point: origin) else { return false }
        var current: Point? = origin
        for element in sequence {
            guard let candidate = current,
                  contains(point: candidate),
                  self[candidate] == element
            else { return false }
            current = self.nextPoint(origin: candidate, direction: direction)
        }

        return true
    }

    func first(where predicate: (Element) throws -> Bool) rethrows -> Point? {
        try points.first { try predicate(self[$0]) }
    }
}

extension Grid<Character>: CustomStringConvertible {
    public var description: String {
        elements
            .map { String($0) }
            .joined(separator: "\n")
    }
}
