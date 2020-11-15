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
        .package(url: "https://github.com/binarybirds/leaf-foundation", from: "1.0.0-beta"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.0.0"),
        /// modules
//        .package(name: "user-module", url: "https://github.com/feather-modules/user", .branch("main")),
//        .package(name: "system-module", url: "https://github.com/feather-modules/system", .branch("main")),
//        .package(name: "admin-module", url: "https://github.com/feather-modules/admin", .branch("main")),
//        .package(name: "api-module", url: "https://github.com/feather-modules/api", .branch("main")),
//        .package(name: "frontend-module", url: "https://github.com/feather-modules/frontend", .branch("main")),
//
//        .package(name: "redirect-module", url: "https://github.com/feather-modules/redirect", .branch("main")),
//        .package(name: "sponsor-module", url: "https://github.com/feather-modules/sponsor", .branch("main")),
//        .package(name: "static-module", url: "https://github.com/feather-modules/static", .branch("main")),
//        .package(name: "blog-module", url: "https://github.com/feather-modules/blog", .branch("main")),
//        .package(name: "swifty-module", url: "https://github.com/feather-modules/swifty", .branch("main")),
//        .package(name: "markdown-module", url: "https://github.com/feather-modules/markdown", .branch("main")),

        
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
//            .product(name: "UserModule", package: "user-module"),
//            .product(name: "SystemModule", package: "system-module"),
//            .product(name: "AdminModule", package: "admin-module"),
//            .product(name: "ApiModule", package: "api-module"),
//            .product(name: "FrontendModule", package: "frontend-module"),

//            .product(name: "RedirectModule", package: "redirect-module"),
//            .product(name: "SponsorModule", package: "sponsor-module"),
//            .product(name: "StaticModule", package: "static-module"),
//            .product(name: "BlogModule", package: "blog-module"),
//            .product(name: "SwiftyModule", package: "swifty-module"),
//            .product(name: "MarkdownModule", package: "markdown-module"),


            .product(name: "Splash", package: "Splash"),
            .product(name: "Ink", package: "Ink"),

            .product(name: "Vapor", package: "vapor"),
        ], exclude: [
            "Modules/User/Templates/",
            "Modules/System/Templates/",
            "Modules/Admin/Templates/",
            "Modules/Frontend/Templates/",
            "Modules/Blog/Templates/",
            "Modules/Static/Templates/",
            "Modules/Redirect/Templates/",
            "Modules/Sponsor/Templates/",
            "Modules/Menu/Templates/",
            "Modules/Blog/Assets/",
            "Modules/Static/Assets/",
            
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
