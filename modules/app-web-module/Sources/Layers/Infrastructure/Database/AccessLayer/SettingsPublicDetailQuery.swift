import FeatherDatabase
public import FeatherInfrastructure
import SystemInfrastructure
import SystemModule
public import WebApplication
public import WebModule

extension Settings.Public.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func get() async throws -> Settings.Public.Detail.Output {
            let pairs = try await SystemModule.Variable.Lookup
                .Database(
                    context: context
                )
                .get(
                    keys: [
                        "web-settings-logo",
                        "web-settings-logo-dark",
                        "web-settings-meta-image",
                        "web-settings-primary-color",
                        "web-settings-secondary-color",
                        "web-settings-tertiary-color",
                        "web-settings-primary-font",
                        "web-settings-secondary-font",
                        "web-settings-home-page-id",
                        "web-settings-locale",
                        "web-settings-timezone",
                        "web-settings-title",
                        "web-settings-excerpt",
                        "web-settings-no-index",
                        "web-settings-css",
                        "web-settings-js",
                    ]
                )

            return .init(
                logo: pairs["web-settings-logo"] ?? "",
                logoDark: pairs["web-settings-logo-dark"] ?? "",
                metaImage: pairs["web-settings-meta-image"] ?? "",
                primaryColor: pairs["web-settings-primary-color"] ?? "",
                secondaryColor: pairs["web-settings-secondary-color"] ?? "",
                tertiaryColor: pairs["web-settings-tertiary-color"] ?? "",
                primaryFont: pairs["web-settings-primary-font"] ?? "",
                secondaryFont: pairs["web-settings-secondary-font"] ?? "",
                homePageId: pairs["web-settings-home-page-id"]
                    .flatMap { $0.isEmpty ? nil : $0 },
                locale: pairs["web-settings-locale"] ?? "en-US",
                timezone: pairs["web-settings-timezone"] ?? "utc",
                title: pairs["web-settings-title"] ?? "",
                excerpt: pairs["web-settings-excerpt"] ?? "",
                noIndex: (pairs["web-settings-no-index"] ?? "false") == "true",
                css: pairs["web-settings-css"] ?? "",
                js: pairs["web-settings-js"] ?? ""
            )
        }
    }
}
