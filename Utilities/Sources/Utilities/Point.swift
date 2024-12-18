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

extension Point: CustomStringConvertible {
    public var description: String {
        "\(col),\(row)"
    }
}
