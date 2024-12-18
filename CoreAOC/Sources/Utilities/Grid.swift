import Algorithms

public struct Grid<Element> {
    private var pointSpace: PointSpace
    public var elements: [[Element]]

    public init(rows: [[Element]]) {
        assert(!rows.isEmpty)
        self.pointSpace = PointSpace(
            width: rows[0].count,
            height: rows.count
        )
        self.elements = rows
    }
}

public extension Grid {
    var minCol: Int { pointSpace.minCol }
    var maxCol: Int { pointSpace.maxCol }
    var minRow: Int { pointSpace.minRow }
    var maxRow: Int { pointSpace.maxRow }
    var rowRange: Range<Int> { pointSpace.rowRange }
    var colRange: Range<Int> { pointSpace.colRange }

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
        pointSpace.points
    }

    func points(from start: Point, direction: Direction) -> some Sequence<Point> {
        pointSpace.points(from: start, direction: direction)
    }

    func nextPoint(origin: Point, direction: Direction, distance: Int = 1) -> Point {
        pointSpace.nextPoint(origin: origin, direction: direction, distance: distance)
    }

    func contains(point: Point) -> Bool {
        pointSpace.contains(point: point)
    }

    func validNeighbors(of point: Point, includeDiagonals: Bool = false) -> Set<Point> {
        pointSpace.validNeighbors(of: point, includeDiagonals: includeDiagonals)
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
