// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "feather",
    platforms: [
       .macOS(.v11)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.34.0"),
        .package(url: "https://github.com/binarybirds/feather-core", from: "1.0.0-beta"),
//        .package(url: "https://github.com/binarybirds/feather-core", .branch("main")),
        .package(url: "https://github.com/binarybirds/leaf-foundation", from: "1.0.0-beta"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.0.0"),

//        .package(name: "redirect-module", url: "https://github.com/feather-modules/redirect", .branch("main")),
//        .package(name: "sponsor-module", url: "https://github.com/feather-modules/sponsor", .branch("main")),
//        .package(name: "static-module", url: "https://github.com/feather-modules/static", .branch("main")),
//        .package(name: "blog-module", url: "https://github.com/feather-modules/blog", .branch("main")),
//        .package(name: "swifty-module", url: "https://github.com/feather-modules/swifty", .branch("main")),
//        .package(name: "markdown-module", url: "https://github.com/feather-modules/markdown", .branch("main")),

        .package(url: "https://github.com/malcommac/UAParserSwift", from: "1.2.0"),
        .package(name: "ALanguageParser", url: "https://github.com/matsoftware/accept-language-parser", from: "1.0.0"),
 
        .package(url: "https://github.com/JohnSundell/Splash", from: "0.15.0"),
        .package(url: "https://github.com/JohnSundell/Ink", from: "0.5.0"),
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
            .product(name: "LeafFoundation", package: "leaf-foundation"),
            
            /// drivers
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),

            /// modules
//            .product(name: "RedirectModule", package: "redirect-module"),
//            .product(name: "SponsorModule", package: "sponsor-module"),
//            .product(name: "StaticModule", package: "static-module"),
//            .product(name: "BlogModule", package: "blog-module"),
//            .product(name: "SwiftyModule", package: "swifty-module"),
//            .product(name: "MarkdownModule", package: "markdown-module"),

            .product(name: "UAParserSwift", package: "UAParserSwift"),
            .product(name: "ALanguageParser", package: "ALanguageParser"),
            
            .product(name: "Splash", package: "Splash"),
            .product(name: "Ink", package: "Ink"),

            .product(name: "Vapor", package: "vapor"),
        ], exclude: [
            "Modules/Analytics/Bundle",
            "Modules/Blog/Bundle",
            "Modules/Menu/Bundle",
            "Modules/Redirect/Bundle",
            "Modules/Site/Bundle",
            "Modules/Sponsor/Bundle",
            "Modules/Static/Bundle",
        ], swiftSettings: [
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]),
        .target(name: "Run", dependencies: [
             .target(name: "App"),
        ]),
//        .testTarget(name: "AppTests", dependencies: [
//            .target(name: "App"),
//            .product(name: "XCTVapor", package: "vapor"),
//        ])
    ]
)
