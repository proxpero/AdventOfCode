public struct Point: Hashable {
    public var row: Int
    public var col: Int

    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

public extension Point {
    func offset(by vector: Vector, distance: Int = 1) -> Self {
        Self(row: self.row + vector.dy * distance, col: self.col + vector.dx * distance)
    }
}

public struct Vector: Hashable {
    public var dx: Int
    public var dy: Int

    public init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }

    static func * (lhs: Vector, rhs: Int) -> Vector {
        Vector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func * (lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
    }
}

