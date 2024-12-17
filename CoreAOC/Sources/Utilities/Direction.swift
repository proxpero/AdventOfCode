public enum Direction: CaseIterable, Sendable {
    case up
    case upRight
    case right
    case rightDown
    case down
    case downLeft
    case left
    case leftUp

    public static let cardinals: [Self] = [.up, .right, .down, .left]
    public static let diagonals: [Self] = [.upRight, .rightDown, .downLeft, .leftUp]
}

public extension Direction {
    var inverse: Self {
        self.rotatedClockwise(by: 4)
    }

    mutating func rotating(_ direction: ClockDirection, by increment: Int = 2) {
        var temp = self
        temp = temp.rotated(direction, by: increment)
        self = temp
    }

    func rotated(_ direction: ClockDirection, by increment: Int = 2) -> Self {
        rotatedClockwise(by: increment * direction.factor)
    }

    // Increments of 45 degrees
    private func rotatedClockwise(by increment: Int = 2) -> Self {
        var increment = increment
        while increment < 0 {
            increment += Self.allCases.count
        }

        let newIndex = (Self.allCases.firstIndex(of: self)! + increment).quotientAndRemainder(
            dividingBy: Self.allCases.count
        ).remainder

        return Self.allCases[newIndex]
    }

    var offsets: Vector {
        switch self {
        case .up: .init(dx: 0, dy: -1)
        case .upRight: .init(dx: 1, dy: -1)
        case .right: .init(dx: 1, dy: 0)
        case .rightDown: .init(dx: 1, dy: 1)
        case .down: .init(dx: 0, dy: 1)
        case .downLeft: .init(dx: -1, dy: 1)
        case .left: .init(dx: -1, dy: 0)
        case .leftUp: .init(dx: -1, dy: -1)
        }
    }
}

public extension Direction {
    enum ClockDirection {
        case clockwise
        case counterClockwise

        var factor: Int {
            switch self {
            case .clockwise: return 1
            case .counterClockwise: return -1
            }
        }
    }
}
