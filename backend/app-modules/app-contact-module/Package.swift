// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature(
        "AvailabilityMacro=ContactModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
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
    name: "app-contact-module",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "ContactDomain", targets: ["ContactDomain"]),
        .library(
            name: "ContactApplication",
            targets: ["ContactApplication"]
        ),
        .library(
            name: "ContactInfrastructure",
            targets: ["ContactInfrastructure"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-beta.5"
        ),
        .package(path: "../app-kernel")
    ],
    targets: [
        .target(
            name: "ContactDomain",
            dependencies: [
                .product(name: "Domain", package: "app-kernel")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "ContactApplication",
            dependencies: [
                .product(name: "Application", package: "app-kernel"),
                .target(name: "ContactDomain"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "ContactInfrastructure",
            dependencies: [
                .product(name: "Infrastructure", package: "app-kernel"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .target(name: "ContactApplication"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "ContactDomainTests",
            dependencies: [
                .target(name: "ContactDomain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "ContactApplicationTests",
            dependencies: [
                .target(name: "ContactApplication")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "ContactInfrastructureTests",
            dependencies: [
                .target(name: "ContactInfrastructure")
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
