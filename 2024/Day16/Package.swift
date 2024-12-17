// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day16",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
        .package(path: "../../CoreAOC")
    ],
    targets: [
        .executableTarget(
            name: "Day16",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Utilities", package: "CoreAOC")
            ],
            resources: [.copy("Input")]
        )
    ]
)
