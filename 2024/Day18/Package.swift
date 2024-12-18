// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day18",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
        .package(path: "../../CoreAOC")
    ],
    targets: [
        .executableTarget(
            name: "Day18",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Utilities", package: "CoreAOC")
            ],
            resources: [.copy("Input")]
        )
    ]
)
