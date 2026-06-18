// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] = [
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature(
        "AvailabilityMacro=AppKernel 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"
    ),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
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
    name: "app-kernel",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Application", targets: ["Application"]),
        .library(name: "Infrastructure", targets: ["Infrastructure"]),
    ],
    dependencies: [
        //        .package(
        //            url: "https://github.com/apple/swift-configuration",
        //            exact: "1.0.2",
        //            traits: [.defaults, "CommandLineArguments"]
        //        ),
        //        .package(
        //            url: "https://github.com/apple/swift-nio",
        //            from: "2.0.0"
        //        ),
        .package(
            url: "https://github.com/swift-server/swift-service-lifecycle.git",
            from: "2.0.0"
        ),
        //        .package(
        //            url: "https://github.com/apple/swift-log",
        //            from: "1.0.0"
        //        ),
        //        .package(
        //            url: "https://github.com/BinaryBirds/swift-nanoid",
        //            from: "1.0.0"
        //        ),
        //        .package(
        //            url: "https://github.com/binarybirds/swift-bcrypt",
        //            from: "2.0.1"
        //        ),
        .package(
            url: "https://github.com/feather-framework/feather-database",
            exact: "1.0.0-beta.5"
        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-database-sqlite",
        //            exact: "1.0.0-beta.9"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-validation",
        //            exact: "1.0.0-beta.1"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-access-control",
        //            branch: "main"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail",
        //            exact: "1.0.0-beta.3"
        //        ),
        //        .package(
        //            url: "https://github.com/feather-framework/feather-mail-ephemeral",
        //            exact: "1.0.0-beta.2"
        //        ),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [

            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "Application",
            dependencies: [
                .target(name: "Domain")
                //                .target(name: "FeatherError"),
                //                .product(name: "FeatherValidation", package: "feather-validation"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "Infrastructure",
            dependencies: [
                .target(name: "Application"),
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(
                    name: "ServiceLifecycle",
                    package: "swift-service-lifecycle"
                ),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                .target(name: "Domain")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [
                .target(name: "Application")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: [
                .target(name: "Infrastructure")
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
