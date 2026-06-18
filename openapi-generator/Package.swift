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
    .enableExperimentalFeature("AvailabilityMacro=OpenAPIGenerator 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"),
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
    name: "openapi-generator",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .executable(name: "AppOpenAPIGenerator", targets: ["AppOpenAPIGenerator"]),
        .executable(name: "AdminOpenAPIGenerator", targets: ["AdminOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-openapi", exact: "1.0.0-beta.7"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit", from: "5.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.2.0"),
    ],
    targets: [
        .target(
            name: "SharedOpenAPIComponents",
            dependencies: [
                .product(name: "FeatherOpenAPI", package: "feather-openapi"),
                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "Yams", package: "Yams"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AppOpenAPIGenerator",
            dependencies: [
                .target(name: "SharedOpenAPIComponents"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .executableTarget(
            name: "AdminOpenAPIGenerator",
            dependencies: [
                .target(name: "SharedOpenAPIComponents"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
