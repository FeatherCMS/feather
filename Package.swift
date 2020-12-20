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
        /// tests
        .package(url: "https://github.com/vapor/vapor", from: "4.34.0"),
        .package(url: "https://github.com/binarybirds/spec.git", from: "1.2.0-beta"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0-beta"),
        /// feather core
        .package(url: "https://github.com/FeatherCMS/feather-core", from: "1.0.0-beta"),
        /// core modules
        .package(url: "https://github.com/FeatherCMS/system-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/user-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/api-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/admin-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/frontend-module", from: "1.0.0-beta"),
        /// other modules
        .package(url: "https://github.com/FeatherCMS/file-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/redirect-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/blog-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/analytics-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/aggregator-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/sponsor-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/swifty-module", from: "1.0.0-beta"),
        .package(url: "https://github.com/FeatherCMS/markdown-module", from: "1.0.0-beta"),        
    ],
    targets: [
        .target(name: "Feather", dependencies: [
            /// drivers
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            /// feather
            .product(name: "FeatherCore", package: "feather-core"),
            /// core modules
            .product(name: "SystemModule", package: "system-module"),
            .product(name: "UserModule", package: "user-module"),
            .product(name: "ApiModule", package: "api-module"),
            .product(name: "AdminModule", package: "admin-module"),
            .product(name: "FrontendModule", package: "frontend-module"),
            /// other modules
            .product(name: "FileModule", package: "file-module"),
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

            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "Spec", package: "spec"),
        ])
    ]
)
