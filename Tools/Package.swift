// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "ToolKit", targets: ["ToolKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
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
        )
    ]
)
