import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AdminGetDesignSystemComponent: Component, FlowContent {

    func content() -> some BasicTag {
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
            P("Button components")

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
