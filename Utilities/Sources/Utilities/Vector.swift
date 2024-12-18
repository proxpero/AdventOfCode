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
