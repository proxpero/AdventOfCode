import Files
import Foundation

public struct Day {
    let year: Year
    public let day: Int

    public init(year: Int, day: Int) {
        self.year = Year(year: year)
        self.day = day
    }
}

public extension Day {
    static var defaultDay: Int {
        Calendar.current.component(.day, from: Date())
    }

    var dayFolder: Folder {
        get throws {
            try year.folder.createSubfolderIfNeeded(withName: "Day\(day)")
        }
    }

    var sourcesFolder: Folder {
        get throws {
            try dayFolder.createSubfolderIfNeeded(withName: "Sources")
        }
    }

    var packageFile: File {
        get throws {
            try dayFolder.createFileIfNeeded(withName: "Package.swift")
        }
    }

    var mainFile: File {
        get throws {
            try sourcesFolder.createFileIfNeeded(withName: "main.swift")
        }
    }

    var inputFile: File {
        get throws {
            try sourcesFolder.createFileIfNeeded(withName: "Input")
        }
    }

    func setInput(_ data: Data) throws {
        try inputFile.write(data)
    }

    func createPackageFile() throws {
        let url = Bundle.module.url(forResource: "Package", withExtension: "txt")!
        var data = try Data(contentsOf: url)
        let template = String(decoding: data, as: UTF8.self)
            .replacingOccurrences(of: "{{day}}", with: "\(day)")
        data = Data(template.utf8)
        try packageFile.write(data)
    }

    // Overwrites current contents
    func createMainFile() throws {
        let url = Bundle.module.url(forResource: "Day", withExtension: "txt")!
        let data = try Data(contentsOf: url)
        try mainFile.write(data)
    }

    func create() throws {
        try createPackageFile()
        try createMainFile()

        let data: Data
        do {
            data = try loadInput()
        } catch {
            data = Data()
        }
        
        try inputFile.write(data)
    }

    func loadInput() throws -> Data {
        try InputLoader(year: year.year, day: day).load()
    }

    func udpateInputInPlace() throws {
        let data = try InputLoader(year: year.year, day: day).load()
        try inputFile.write(data)
    }
}
