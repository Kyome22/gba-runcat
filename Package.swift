// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "runcat",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "runcat",
            targets: ["runcat"]
        ),
    ],
    targets: [
        .target(
            name: "runcat",
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
            ]
        ),
    ]
)
