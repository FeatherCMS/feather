// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature("AvailabilityMacro=NewsletterModule 1.0:macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
]

#if compiler(>=6.2)
defaultSwiftSettings.append(.enableUpcomingFeature("NonisolatedNonsendingByDefault"))
#endif

let package = Package(
    name: "app-newsletter-module",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(name: "NewsletterDomain", targets: ["NewsletterDomain"]),
        .library(name: "NewsletterApplication", targets: ["NewsletterApplication"]),
        .library(name: "NewsletterInfrastructure", targets: ["NewsletterInfrastructure"])
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-database", exact: "1.0.0-beta.5"),
        .package(path: "../app-kernel")
    ],
    targets: [
        .target(name: "NewsletterDomain", dependencies: [.product(name: "Domain", package: "app-kernel")], swiftSettings: defaultSwiftSettings),
        .target(name: "NewsletterApplication", dependencies: [.product(name: "Application", package: "app-kernel"), .target(name: "NewsletterDomain")], swiftSettings: defaultSwiftSettings),
        .target(name: "NewsletterInfrastructure", dependencies: [.product(name: "Infrastructure", package: "app-kernel"), .product(name: "FeatherDatabase", package: "feather-database"), .target(name: "NewsletterApplication")], swiftSettings: defaultSwiftSettings),
        .testTarget(name: "NewsletterDomainTests", dependencies: [.target(name: "NewsletterDomain")], swiftSettings: defaultSwiftSettings),
        .testTarget(name: "NewsletterApplicationTests", dependencies: [.target(name: "NewsletterApplication")], swiftSettings: defaultSwiftSettings),
        .testTarget(name: "NewsletterInfrastructureTests", dependencies: [.target(name: "NewsletterInfrastructure")], swiftSettings: defaultSwiftSettings)
    ]
)
