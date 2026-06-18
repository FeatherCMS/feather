// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] =
[
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature("AvailabilityMacro=webapp 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

defaultSwiftSettings += [
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
]

let package = Package(
    name: "web-app",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .executable(name: "WebApp", targets: ["WebApp"]),
        .executable(name: "Static", targets: ["Static"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hummingbird-project/hummingbird",
            from: "2.20.1"
        ),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-auth",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-configuration",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/BinaryBirds/swift-web-standards",
            exact: "1.0.0-beta.2"
        ),
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-markdown",
            from: "0.8.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-async-http-client",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/feather-framework/feather-validation",
            exact: "1.0.0-beta.1"
        ),
        .package(path: "../openapi"),
    ],
    targets: [
        .executableTarget(
            name: "Static",
                dependencies: [
                    .product(name: "Configuration", package: "swift-configuration"),
                    .product(name: "Hummingbird", package: "hummingbird"),
                ],
        ),
        .executableTarget(
            name: "WebApp",
                dependencies: [
                    .product(name: "Configuration", package: "swift-configuration"),
                    .product(name: "Hummingbird", package: "hummingbird"),
                    .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                    .product(name: "Markdown", package: "swift-markdown"),
                    .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                    .product(name: "FeatherValidation", package: "feather-validation"),
                    .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                    .product(name: "Mustache", package: "swift-mustache"),
                    .product(name: "WebStandards", package: "swift-web-standards"),
                    .product(name: "AppOpenAPI", package: "openapi"),
                    .product(name: "AdminOpenAPI", package: "openapi"),
                ],
                resources: [
                    .copy("Resources/Themes"),
                ],
        ),
        .testTarget(
            name: "WebAppTests",
            dependencies: [
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .target(name: "WebApp"),
            ]
        )
    ]
)
