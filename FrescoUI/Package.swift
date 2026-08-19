// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FrescoUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "FrescoUI", targets: ["FrescoUI"]),
        .library(name: "MenuServiceInterface", targets: ["MenuServiceInterface"]),
        .library(name: "MenuUI", targets: ["MenuUI"])
    ],
    targets: [
        .target(
            name: "FrescoUI"
        ),
        .target(
            name: "MenuServiceInterface"
        ),
        .target(
            name: "MenuUI",
            dependencies: ["FrescoUI", "MenuServiceInterface"]
        ),
        .testTarget(
            name: "FrescoUITests",
            dependencies: ["FrescoUI"]
        ),
        .testTarget(
            name: "MenuUITests",
            dependencies: ["MenuUI", "MenuServiceInterface"]
        )
    ]
)
