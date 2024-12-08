// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NutriCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "NutriCore",
            targets: [
                "NutriCore",
                "NutriData"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", exact: "600.0.1"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.3"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "NutriData",
            dependencies: [
                "NutriCore"
            ],
            plugins: [
                "GenerateDataPlugin"
            ]
        ),
        .plugin(
            name: "GenerateDataPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "GenerateData")
            ]
        ),
        .executableTarget(
            name: "GenerateData",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "Yams", package: "yams"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "NutriCore",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NutriCoreTests",
            dependencies: [
                "NutriData"
            ]
        )
    ]
)
