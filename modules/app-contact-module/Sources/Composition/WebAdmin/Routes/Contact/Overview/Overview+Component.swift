import CSS
import FeatherWebAdmin
import FeatherWebShared
import HTML
import WebBuilders
import WebComponents

extension Contact.Overview {
    struct Component: WebComponents.Component {
        struct Destination {
            let title: String
            let description: String
            let href: String
            let icon: String
        }

        let routes: Contact.Router.Routes

        private var destinations: [Destination] {
            [
                Destination(
                    title: "Forms",
                    description:
                        "Manage contact forms and their configuration.",
                    href: routes.forms.path,
                    icon: "clipboard"
                ),
                Destination(
                    title: "Fields",
                    description: "Manage reusable fields for contact forms.",
                    href: routes.fields.path,
                    icon: "list"
                ),
                Destination(
                    title: "Submissions",
                    description:
                        "Review and manage submitted contact messages.",
                    href: routes.submissions.path,
                    icon: "inbox"
                ),
            ]
        }

        func rules() -> [any Rule] {
            Media {
                Custom(".contact-overview-destinations") {
                    Margin(top: 8.px)
                    RowGap(16.px)
                    ColumnGap(16.px)
                }
                Custom(".contact-overview-destination") {
                    Display(.flex)
                    FlexDirection(.column)
                    AlignItems(.flexStart)
                    Gap(12.px)
                    Padding(24.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                    BorderRadius(12.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Tertiary.tint)
                    )
                }
                Custom(
                    ".contact-overview-destination h2, .contact-overview-destination p"
                ) { Margin(0) }
                Custom(".contact-overview-destination h2 + p") {
                    Margin(top: (-6).px)
                }
                Custom(".contact-overview-destination p") {
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    LineHeight(1.5)
                }
                Custom(".contact-overview-destination .admin-button") {
                    Margin(top: 4.px)
                }
            }
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(AdminBreadcrumb(links: routes.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Contact",
                            description:
                                "Manage contact forms, fields, and submissions."
                        )
                    )
                )
                Div {
                    for destination in destinations {
                        Div {
                            if let icon = FeatherIcons.get(
                                named: destination.icon
                            ) {
                                icon
                            }
                            H2(destination.title)
                            P(destination.description)
                            context.build(
                                AdminButton(
                                    "Open",
                                    href: destination.href,
                                    style: .primary
                                )
                            )
                        }
                        .class("contact-overview-destination")
                    }
                }
                .class("grid grid-221 contact-overview-destinations")
            }
            .class("cms-section")
        }
    }
}
