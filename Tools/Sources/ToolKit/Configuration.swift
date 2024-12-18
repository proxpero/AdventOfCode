import Files
import Foundation

public struct InputLoader {
    let year: Int
    let day: Int

    var url: URL {
        URL(string: "https://adventofcode.com/\(year)/day/\(day)/input")!
    }

    func load() throws(InputLoader.Error) -> Data {
        do {
            try Configuration().setSharedSessionCookie()
        } catch {
            fatalError()
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw .init(
                year: year,
                day: day,
                url: url.absoluteString,
                path: try! Configuration.file.path,
                session: try! Configuration().session,
                kind: .downloadFailed
            )
        }

        if String(decoding: data, as: UTF8.self).contains("Please log in to get your puzzle input.") {
            fatalError()
        }

        return data
    }

    struct Error: Swift.Error {
        enum Kind {
            case downloadFailed
            case unauthorized
        }

        let year: Int
        let day: Int
        let url: String
        let path: String
        let session: String?
        let kind: Kind
    }
}

public struct Configuration: Codable {
    var sessionCookie: String?

    init(sessionCookie: String? = nil) {
        self.sessionCookie = sessionCookie
    }
}

extension Configuration {
    public enum Error: Swift.Error {
        case noSessionCookie
        case couldNotCreate(filename: String, folder: String)
        case couldNotFind(filename: String, folder: String)
        case couldNotRead
        case couldNotLoad
        case couldNotSetSessionCookie
        case downloadFailed(year: Int, day: Int)
        case unauthorized
    }

    private static let decoder = JSONDecoder()
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    static var file: File {
        get throws {
            let filename = ".config"
            return try Folder.current.createFileIfNeeded(at: filename)
        }
    }

    public var session: String? {
        get throws(Configuration.Error) {
            try Self.load().sessionCookie
        }
    }

    public func setSession(_ session: String) throws {
        var config = try Self.load()
        config.sessionCookie = session
        let data = try Self.encoder.encode(config)
        try Self.file.write(data)
    }

    public static func load() throws(Configuration.Error) -> Configuration {
        do {
            let data = try Configuration.file.read()
            let config = try Self.decoder.decode(Configuration.self, from: data)
            return config
        } catch {
            throw Configuration.Error.couldNotLoad
        }
    }

    public func setSharedSessionCookie() throws(Configuration.Error) {
        let session = try self.session
        guard let session else {
            throw Configuration.Error.noSessionCookie
        }

        let cookie = HTTPCookie(properties: [
            .domain: ".adventofcode.com",
            .path: "/",
            .secure: "true",
            .name: "session",
            .value: session
        ])!

        HTTPCookieStorage.shared.setCookie(cookie)
    }

    public func loadInput() throws {
        try setSharedSessionCookie()

    }
}
