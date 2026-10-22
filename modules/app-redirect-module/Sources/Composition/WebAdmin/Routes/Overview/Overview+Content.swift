import CSS
import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectModule
import WebBuilders
import WebComponents

extension Overview {
    struct Content: Component {
        let routes: RedirectModule.Rule.Router.Routes
        struct Destination {
            let title: String
            let description: String
            let href: String
            let icon: String
        }

        private var destinations: [Destination] {
            [
                Destination(
                    title: "Redirect rules",
                    description:
                        "Manage paths that redirect to other destinations.",
                    href: routes.list.path,
                    icon: "cornerUpRight"
                ),
                Destination(
                    title: "Add a rule",
                    description: "Create a permanent or temporary redirect.",
                    href: routes.add.path,
                    icon: "plusCircle"
                ),
            ]
        }

        func rules() -> [any CSS.Rule] {
            Media {
                Custom(".redirect-overview-destinations") {
                    Margin(top: 8.px)
                    RowGap(16.px)
                    ColumnGap(16.px)
                }
                Custom(".redirect-overview-destination") {
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
                    ".redirect-overview-destination h2, .redirect-overview-destination p"
                ) { Margin(0) }
                Custom(".redirect-overview-destination h2 + p") {
                    Margin(top: (-6).px)
                }
                Custom(".redirect-overview-destination p") {
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    LineHeight(1.5)
                }
                Custom(".redirect-overview-destination .admin-button") {
                    Margin(top: 4.px)
                }
            }
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.redirectBreadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Redirect",
                            description:
                                "Manage redirect rules for the application."
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
                        .class("redirect-overview-destination")
                    }
                }
                .class("grid grid-221 redirect-overview-destinations")
            }
            .class("cms-section")
        }
    }
}
