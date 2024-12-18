import Algorithms
import Collections
import Utilities
import Foundation

var timer = Date()
var input = try load(from: .module)

//input = """
//Register A: 729
//Register B: 0
//Register C: 0
//
//Program: 0,1,5,4,3,0
//"""

//input = """
//Register A: 0
//Register B: 0
//Register C: 9
//
//Program: 2,6
//"""

//input = """
//Register A: 10
//Register B: 0
//Register C: 0
//
//Program: 5,0,5,1,5,4
//"""
//
//input = """
//Register A: 2024
//Register B: 0
//Register C: 0
//
//Program: 0,1,5,4,3,0
//"""
//
//input = """
//Register A: 0
//Register B: 29
//Register C: 0
//
//Program: 1,7
//"""
//
//input = """
//Register A: 0
//Register B: 2024
//Register C: 43690
//
//Program: 4,0
//"""

//input = """
//Register A: 2024
//Register B: 0
//Register C: 0
//
//Program: 0,3,5,4,3,0
//"""

enum Instruction: Int {
    case adv
    case bxl
    case bst
    case jnz
    case bxc
    case out
    case bdv
    case cdv
}

struct State {
    typealias Register = Int
    var A: Register = 0
    var B: Register = 0
    var C: Register = 0
}

extension State {
    init(lines: [String.SubSequence]) {
        self.A = Int(lines[0].drop(while: { !$0.isNumber }))!
        self.B = Int(lines[1].drop(while: { !$0.isNumber }))!
        self.C = Int(lines[2].drop(while: { !$0.isNumber }))!
    }
}

// MARK: Parsing

let lines = input.split(separator: "\n")
var state = State(lines: lines)
let program = lines[3].drop(while: { !$0.isNumber }).split(separator: ",").map { Int($0)! }

parsing(&timer)

// MARK: Part 1

func run(program: [Int], initialState: State) -> [Int] {
    var pointer = 0
    var state = initialState
    var output: [Int] = []

    func combo(_ value: Int) -> Int {
        switch value {
        case 0...3: value
        case 4: state.A
        case 5: state.B
        case 6: state.C
        case 7: fatalError("Reserved")
        default: fatalError()
        }
    }

    while program.indices.contains(pointer) {
        let operand = program[pointer + 1]
        let instruction = Instruction(rawValue: program[pointer])!

        switch instruction {
        case .adv:
            state.A /= pow(2, combo(operand))
        case .bxl:
            state.B ^= operand
        case .bst:
            state.B = combo(operand) % 8
        case .jnz where state.A == 0:
            break
        case .jnz:
            pointer = operand
            continue
        case .bxc:
            state.B ^= state.C
        case .out:
            output.append(combo(operand) % 8)
        case .bdv:
            state.B = state.A / pow(2, combo(operand))
        case .cdv:
            state.C = state.A / pow(2, combo(operand))
        }

        pointer += 2
    }

    return output
}

let p1 = run(program: program, initialState: state)
    .map(String.init)
    .joined(separator: ",")

part1(p1, &timer)

// MARK: Part 2

var candidates = Deque<(register: Int, digits: Int)>()
candidates.append((register: 0, digits: 1))

var p2 = -1
main: while let (register, digits) = candidates.popFirst() {
    for num in 0...7 {
        let next = register << 3 + num
        let output = run(program: program, initialState: State(A: next))
        if output == program.suffix(digits) {
            if digits == program.count {
                p2 = next
                break main
            }
            candidates.append((register: next, digits: digits + 1))
        }
    }
}

part2(p2, &timer)

// MARK: Additions

func pow(_ base: Int, _ exponent: Int) -> Int {
    Int(pow(Double(base), Double(exponent)))
}
