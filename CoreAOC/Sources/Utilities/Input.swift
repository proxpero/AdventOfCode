import Foundation

public func load(from bundle: Bundle) throws -> String {
    let result = try bundle.url(forResource: "Input", withExtension: nil).flatMap {
        try String(contentsOf: $0, encoding: .utf8)
    }

    guard let result else {
        fatalError("Could not read input from resource.")
    }

    return result.trimmingCharacters(in: .whitespacesAndNewlines)
}
