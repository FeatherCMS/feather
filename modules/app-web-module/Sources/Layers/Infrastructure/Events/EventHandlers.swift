import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import WebApplication
import WebContracts
import WebDomain

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebMenuProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "main",
                    name: "Main Menu",
                    notes: "Main navigation."
                )
            ]
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    value: "web.page",
                    title: "Web page"
                )
            ]
        }

        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            WebPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: WebPageProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    title: "Welcome Page",
                    excerpt: "This is the welcome page",
                    content: #"""
                        # Welcome

                        This page is provided by the web module.
                        """#,
                    metadata: .init(
                        template: "default",
                        slug: "web.welcome",
                        status: .published
                    )
                )
            ]
        }

        registry.register(
            event: VariableSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            [
                .init(
                    key: "web-settings-logo",
                    value: "",
                    name: "Website logo",
                    notes: "Logo of the website"
                ),
                .init(
                    key: "web-settings-public-base-url",
                    value: "http://localhost:3456",
                    name: "Website public base URL",
                    notes: "Canonical public URL of the website"
                ),
                .init(
                    key: "web-settings-logo-dark",
                    value: "",
                    name: "Website dark logo",
                    notes: "Logo of the website in dark mode"
                ),
                .init(
                    key: "web-settings-meta-image",
                    value: "",
                    name: "Website metadata image",
                    notes: "Default metadata image of the website"
                ),
                .init(
                    key: "web-settings-primary-color",
                    value: "",
                    name: "Website primary color",
                    notes: "Primary color of the website"
                ),
                .init(
                    key: "web-settings-secondary-color",
                    value: "",
                    name: "Website secondary color",
                    notes: "Secondary color of the website"
                ),
                .init(
                    key: "web-settings-tertiary-color",
                    value: "",
                    name: "Website tertiary color",
                    notes: "Tertiary color of the website"
                ),
                .init(
                    key: "web-settings-primary-font",
                    value: "",
                    name: "Website primary font",
                    notes: "Primary font of the website"
                ),
                .init(
                    key: "web-settings-secondary-font",
                    value: "",
                    name: "Website secondary font",
                    notes: "Secondary font of the website"
                ),
                .init(
                    key: "web-settings-home-page-id",
                    value: "",
                    name: "Website home page",
                    notes: "Selected home page of the website"
                ),
                .init(
                    key: "web-settings-locale",
                    value: "en_us",
                    name: "Website locale",
                    notes: "Default locale of the website"
                ),
                .init(
                    key: "web-settings-timezone",
                    value: "utc",
                    name: "Website timezone",
                    notes: "Default timezone of the website"
                ),
                .init(
                    key: "web-settings-title",
                    value: "",
                    name: "Website title",
                    notes: "Title of the website"
                ),
                .init(
                    key: "web-settings-excerpt",
                    value: "",
                    name: "Website excerpt",
                    notes: "Excerpt for the website"
                ),
                .init(
                    key: "web-settings-no-index",
                    value: "false",
                    name: "Disable website indexing",
                    notes: "Disable site indexing by search engines"
                ),
                .init(
                    key: "web-settings-css",
                    value: "",
                    name: "Website custom CSS",
                    notes: "Global CSS injection for the site"
                ),
                .init(
                    key: "web-settings-js",
                    value: "",
                    name: "Website custom JavaScript",
                    notes: "Global JavaScript injection for the site"
                ),
            ]
        }

    }
}
