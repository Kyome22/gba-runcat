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
    ],
    targets: [
        .target(
            name: "RunCat",
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
            ]
        ),
    ]
)
