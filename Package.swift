// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "feather",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.27.0"),
        .package(url: "https://github.com/vapor/leaf", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        //.package(url: "https://github.com/vapor/fluent-postgres-driver", from: "2.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt", from: "4.0.0"),

        .package(url: "https://github.com/binarybirds/content-api", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/view-kit", from: "1.1.0"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/viper-kit", from: "1.3.0"),
        
        .package(url: "https://github.com/JohnSundell/Splash", from: "0.13.0"),
        .package(url: "https://github.com/JohnSundell/Ink", from: "0.5.0"),
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Leaf", package: "leaf"),
            .product(name: "Fluent", package: "fluent"),
            //.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "JWT", package: "jwt"),

            .product(name: "ContentApi", package: "content-api"),
            .product(name: "ViewKit", package: "view-kit"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            .product(name: "ViperKit", package: "viper-kit"),

            .product(name: "Splash", package: "Splash"),
            .product(name: "Ink", package: "Ink"),
        ], swiftSettings: [
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]),
        .target(name: "Run", dependencies: [
             .target(name: "App"),
        ]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
