// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "RunCat",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "RunCat",
            targets: ["RunCat"]
        ),
        .executable(
            name: "ic",
            targets: ["ImageConverter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
    ],
    targets: [
        .target(
            name: "RunCat",
            swiftSettings: [
                .enableExperimentalFeature("Volatile"),
            ]
        ),
        .executableTarget(
            name: "ImageConverter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
            ]
        )
    ]
)
