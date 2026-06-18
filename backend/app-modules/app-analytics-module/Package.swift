// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature(
        "AvailabilityMacro=AnalyticsModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
    ),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

defaultSwiftSettings += [
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .unsafeFlags(
        ["-cross-module-optimization"],
        .when(configuration: .release)
    ),
]

let package = Package(
    name: "app-analytics-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "AnalyticsDomain", targets: ["AnalyticsDomain"]),
        .library(
            name: "AnalyticsApplication",
            targets: ["AnalyticsApplication"]
        ),
        .library(
            name: "AnalyticsInfrastructure",
            targets: ["AnalyticsInfrastructure"]
        ),
    ],
    dependencies: [
        .package(path: "../app-kernel")
    ],
    targets: [
        .target(
            name: "AnalyticsDomain",
            dependencies: [
                .product(name: "Domain", package: "app-kernel")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AnalyticsApplication",
            dependencies: [
                .product(name: "Application", package: "app-kernel"),
                .target(name: "AnalyticsDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "AnalyticsInfrastructure",
            dependencies: [
                .product(name: "Infrastructure", package: "app-kernel"),
                .target(name: "AnalyticsApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
