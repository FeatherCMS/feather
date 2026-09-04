import FeatherAdmin
import Hummingbird
import HTML
import SGML
import WebComponents
import WebBuilders


struct AdminGetDesignSystemDefaultController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/design-system",
            use: getDesignSystem
        )
    }

    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let body = RootBody(state: .init(content: AdminGetDesignSystemComponent()))

        let origins = AppEnvironmentStore.current.publicOrigins

        let head = Metadata(
                canonicalUrl: "\(origins.siteBaseURL)/admin/design-system/",
                title: "Design System",
                description: "Feather admin design-system component showcase",
                imageUrl: "\(origins.staticBaseURL)/images/logos/logo.png",
                noIndex: true
            ).html()

        return .init(
            Html {
                head
                body.html()
            }
            .lang("en-US")
        )
    }

}

struct AdminGetDesignSystemComponent: Leaf {

    func html() -> Section {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Design System").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Design System")
            P("Design-system component showcase")


            Section {
                H2("Tokens")
                P("Basic color, background, and link tokens.")
                Div {
                    Div { Span("Primary background") }
                        .class("design-system-token design-system-token--primary")
                    Div { Span("Secondary background") }
                        .class("design-system-token design-system-token--secondary")
                    Div { Span("Subtle background") }
                        .class("design-system-token design-system-token--subtle")
                    Div { Span("Destructive background") }
                        .class("design-system-token design-system-token--destructive")
                }
                .class("design-system-token-list")
                P {
                    A("Primary link")
                        .href("#primary-link")
                        .class("design-system-token-link")
                    A("Hover link")
                        .href("#hover-link")
                        .class("design-system-token-link")
                }
            }
            .class("cms-section")

            Section {
                H2("Buttons")
                Div {
                    PrimaryButton("Primary", href: "#primary")
                    SecondaryButton("Secondary", href: "#secondary")
                    DestructiveButton("Destructive", href: "#destructive")
                }
                .class("button-row")
            }
            .class("cms-section")

            Section {
                H2("Action buttons")
                Div {
                    PrimaryActionButton("Primary action", href: "#primary-action")
                    SecondaryActionButton("Secondary action", href: "#secondary-action")
                    DestructiveActionButton(
                        "Destructive action",
                        href: "#destructive-action"
                    )
                }
                .class("button-row")
            }
            .class("cms-section")
        }
        .class("cms-section")
    }
}
