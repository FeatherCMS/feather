// swift-tools-version:5.5
import PackageDescription

let isLocalDevMode = false

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
    .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.3.0"),
]

if isLocalDevMode {
    dependencies += [
        .package(path: "../feather-core"),
        .package(path: "../analytics-module"),
        .package(path: "../aggregator-module"),
        .package(path: "../blog-module"),
        .package(path: "../markdown-module"),
        .package(path: "../redirect-module"),
        .package(path: "../swifty-module"),
    ]
}
else {
    dependencies += [
        .package(url: "https://github.com/feathercms/feather-core", .branch("dev")),
        .package(url: "https://github.com/feathercms/analytics-module", .branch("dev")),
        .package(url: "https://github.com/feathercms/aggregator-module", .branch("dev")),
        .package(url: "https://github.com/feathercms/blog-module", .branch("dev")),
        .package(url: "https://github.com/feathercms/markdown-module", .branch("dev")),
        .package(url: "https://github.com/feathercms/redirect-module", .branch("dev")),
        .package(url: "https://github.com/feathercms/swifty-module", .branch("dev")),
    ]
}

let package = Package(
    name: "feather",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .executable(name: "Feather", targets: ["Feather"]),
    ],
    dependencies: dependencies,
    targets: [
        .executableTarget(name: "Feather", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            .product(name: "AnalyticsModule", package: "analytics-module"),
            .product(name: "AggregatorModule", package: "aggregator-module"),
            .product(name: "BlogModule", package: "blog-module"),
            .product(name: "RedirectModule", package: "redirect-module"),
            .product(name: "SwiftyModule", package: "swifty-module"),
            .product(name: "MarkdownModule", package: "markdown-module"),
        ], exclude: [
            "Modules/README.md",
        ], swiftSettings: [
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]),
//        .testTarget(name: "FeatherTests", dependencies: [
//            .target(name: "Feather"),
//            .product(name: "FeatherTest", package: "feather-core")
//        ])
    ]
)
