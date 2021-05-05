// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "feather",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Feather", targets: ["Feather"]),
    ],
    dependencies: [
        /// feather core
        .package(url: "https://github.com/FeatherCMS/feather-core", .branch("main")), //from: "1.0.0-beta"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver", from: "2.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0"),
        /// modules
        .package(url: "https://github.com/FeatherCMS/redirect-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/blog-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/analytics-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/aggregator-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/sponsor-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/swifty-module", .branch("main")),//from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/markdown-module", .branch("main")),//from: "1.0.0-beta"),
    ],
    targets: [
        .target(name: "Feather", dependencies: [
            /// feather
            .product(name: "FeatherCore", package: "feather-core"),
            /// drivers
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            /// other modules
            .product(name: "RedirectModule", package: "redirect-module"),
            .product(name: "BlogModule", package: "blog-module"),
            .product(name: "AnalyticsModule", package: "analytics-module"),
            .product(name: "AggregatorModule", package: "aggregator-module"),
            .product(name: "SponsorModule", package: "sponsor-module"),
            .product(name: "SwiftyModule", package: "swifty-module"),
            .product(name: "MarkdownModule", package: "markdown-module"),
        ], exclude: [
            "Modules/README.md",
        ], swiftSettings: [
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]),
        .testTarget(name: "FeatherTests", dependencies: [
            .target(name: "Feather"),
            .product(name: "FeatherTest", package: "feather-core")
        ])
    ]
)
