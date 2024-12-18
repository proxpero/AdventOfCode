// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4")
    ],
    targets: [
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
        ),
    ]
)
