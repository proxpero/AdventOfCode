// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreAOC",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Utilities", targets: ["Utilities"]),
        .library(name: "ToolKit", targets: ["ToolKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4")
    ],
    targets: [
        .executableTarget(
            name: "aoc",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
                .target(name: "ToolKit")
            ]
        ),
        .target(
            name: "ToolKit",
            dependencies: [
                .product(name: "Files", package: "Files")
            ],
            resources: [.copy("Resources")]
        ),
        .target(
            name: "Utilities",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        )
    ]
)
