import FeatherAdmin
import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

struct AdminGetDesignSystemComponent: Leaf {

    func rules() -> [any Rule] {
        Media {
            Custom(".button-row .feather-button") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Border(1.px, .solid, .variable(TokenKey.Colors.Border.primary))
                Background(.variable(TokenKey.Colors.Background.primary))
                Color(.variable(TokenKey.Colors.Text.primary))
                FontWeight(.number(700))
                BorderRadius(999.px)
                Padding(vertical: 8.px, horizontal: 14.px)
                Cursor(.pointer)
                TextDecoration(.none)
                UnsafeRawProperty(
                    name: "transition",
                    value: "background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease"
                )
            }
            Custom(".button-row .feather-button--primary") {
                Background(.variable(TokenKey.Colors.Link.default))
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Color(.variable(TokenKey.Colors.Background.primary))
            }
            Custom(".button-row .feather-button--primary:hover") {
                Background(.variable(TokenKey.Colors.Link.hover))
                BorderColor(.variable(TokenKey.Colors.Link.hover))
                Color(.variable(TokenKey.Colors.Background.primary))
            }
            Custom(".button-row .feather-button--secondary") {
                Background(.variable(TokenKey.Colors.Background.primary))
                BorderColor(.variable(TokenKey.Colors.Border.primary))
                Color(.variable(TokenKey.Colors.Text.primary))
            }
            Custom(".button-row .feather-button--secondary:hover") {
                Background(.variable(TokenKey.Colors.Background.secondary))
                BorderColor(.variable(TokenKey.Colors.Border.secondary))
                Color(.variable(TokenKey.Colors.Text.primary))
            }
            Custom(".button-row .feather-button--action") {
                Padding(vertical: 7.px, horizontal: 10.px)
                BorderRadius(6.px)
            }
        }
    }

    func html() -> Section {
        Section {

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
