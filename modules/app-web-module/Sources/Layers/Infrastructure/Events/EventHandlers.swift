import WebContracts
import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import WebApplication
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
            event: WebPageTemplateOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    value: "default",
                    title: "Default"
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
                    id: "web-settings-logo",
                    value: "",
                    name: "web.site.logo",
                    notes: "Logo of the website"
                ),
                .init(
                    id: "web-settings-logo-dark",
                    value: "",
                    name: "web.site.logo_dark",
                    notes: "Logo of the website in dark mode"
                ),
                .init(
                    id: "web-settings-meta-image",
                    value: "",
                    name: "web.site.meta_image",
                    notes: "Default metadata image of the website"
                ),
                .init(
                    id: "web-settings-primary-color",
                    value: "",
                    name: "web.site.primary_color",
                    notes: "Primary color of the website"
                ),
                .init(
                    id: "web-settings-secondary-color",
                    value: "",
                    name: "web.site.secondary_color",
                    notes: "Secondary color of the website"
                ),
                .init(
                    id: "web-settings-tertiary-color",
                    value: "",
                    name: "web.site.tertiary_color",
                    notes: "Tertiary color of the website"
                ),
                .init(
                    id: "web-settings-primary-font",
                    value: "",
                    name: "web.site.primary_font",
                    notes: "Primary font of the website"
                ),
                .init(
                    id: "web-settings-secondary-font",
                    value: "",
                    name: "web.site.secondary_font",
                    notes: "Secondary font of the website"
                ),
                .init(
                    id: "web-settings-home-page-id",
                    value: "",
                    name: "web.site.home_page_id",
                    notes: "Selected home page of the website"
                ),
                .init(
                    id: "web-settings-locale",
                    value: "en_us",
                    name: "web.site.locale",
                    notes: "Default locale of the website"
                ),
                .init(
                    id: "web-settings-timezone",
                    value: "utc",
                    name: "web.site.timezone",
                    notes: "Default timezone of the website"
                ),
                .init(
                    id: "web-settings-title",
                    value: "",
                    name: "web.site.title",
                    notes: "Title of the website"
                ),
                .init(
                    id: "web-settings-excerpt",
                    value: "",
                    name: "web.site.excerpt",
                    notes: "Excerpt for the website"
                ),
                .init(
                    id: "web-settings-no-index",
                    value: "false",
                    name: "web.site.no_index",
                    notes: "Disable site indexing by search engines"
                ),
                .init(
                    id: "web-settings-css",
                    value: "",
                    name: "web.site.css",
                    notes: "Global CSS injection for the site"
                ),
                .init(
                    id: "web-settings-js",
                    value: "",
                    name: "web.site.js",
                    notes: "Global JavaScript injection for the site"
                ),
            ]
        }

    }
}
