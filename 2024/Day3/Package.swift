// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day3",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
        .package(path: "../../Utilities")
    ],
    targets: [
        .executableTarget(
            name: "Day3",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Utilities", package: "Utilities")
            ],
            resources: [.copy("Input")]
        )
    ]
)
