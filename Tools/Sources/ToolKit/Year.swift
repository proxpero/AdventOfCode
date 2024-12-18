import Files
import Foundation

public struct Year {
    public let year: Int

    public init(year: Int) {
        self.year = year
    }
}

public extension Year {
    var folder: Folder {
        get throws {
            try Folder.current.createSubfolderIfNeeded(withName: "\(year)")
        }
    }

    var existingDays: [Day] {
        get throws {
            try folder.subfolders
                .filter { $0.name.hasPrefix("Day") }
                .map { Day(year: year, day: Int($0.name.dropFirst("Day".count))!) }
        }
    }

    var playgroundName: String {
        "AOC\(year).playground"
    }

    var workspaceName: String {
        "AOC\(year).xcworkspace"
    }

    var playgroundExists: Bool {
        get throws {
            try folder.containsSubfolder(named: playgroundName)
        }
    }

    var playground: Folder {
        get throws {
            try folder.createSubfolderIfNeeded(withName: playgroundName)
        }
    }

    var workspace: Folder {
        get throws {
            try folder.createSubfolderIfNeeded(withName: workspaceName)
        }
    }

    var playgroundContents: String {
        return """
        import Algorithms
        import Utilities
        
        print("done")
        
        """
    }

    func createPlaygroundIfNecessary() throws {
        if try playgroundExists {
            return
        }

        let contents = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <playground version='7.0' target-platform='macos' swift-version='6' buildActiveScheme='true' importAppTypes='true'/>
        """

        try playground.createFile(named: "Contents.swift", contents: playgroundContents.data(using: .utf8))
        try playground.createFile(named: "contents.xcplayground", contents: contents.data(using: .utf8))
    }

    func createWorkspace() throws {
        var contents = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Workspace
            version = "1.0">
        
        """

        if try playgroundExists {
            contents.append("""
                <FileRef
                    location = "group:AOC\(year).playground">
                </FileRef>
            
            """)
        }

        let days = try folder.subfolders
            .filter { $0.name.hasPrefix("Day") }
            .map { $0.name.dropFirst("Day".count) }
            .map { Int($0)! }
            .sorted()

        for day in days {
            contents.append("""
                <FileRef
                    location = "group:Day\(day)">
                </FileRef>
            
            """)
        }

        contents.append("""
        </Workspace>
        
        """)

        try workspace.createFile(named: "contents.xcworkspacedata", contents: contents.data(using: .utf8))
    }
}

