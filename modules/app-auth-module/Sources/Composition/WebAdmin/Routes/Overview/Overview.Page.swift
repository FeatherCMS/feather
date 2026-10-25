import AuthModule
import CSS
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension Overview {
    struct Page: WebComponents.Component {
        let routes: Router.Routes
        struct Destination {
            let title: String
            let description: String
            let href: String
            let icon: String
        }

        private var destinations: [Destination] {
            [
                Destination(
                    title: "Emails",
                    description:
                        "Manage email addresses and verification state.",
                    href: routes.email.list.path,
                    icon: "mail"
                ),
                Destination(
                    title: "Credentials",
                    description:
                        "Manage password credentials for user identities.",
                    href: routes.credential.list.path,
                    icon: "key"
                ),
                Destination(
                    title: "Magic links",
                    description: "Manage passwordless sign-in links.",
                    href: routes.magicLink.list.path,
                    icon: "link"
                ),
                Destination(
                    title: "Access control",
                    description:
                        "Configure roles and authentication permissions.",
                    href: routes.accessControl.edit.path,
                    icon: "lock"
                ),
            ]
        }

        func rules() -> [any Rule] {
            Media {
                Custom(".auth-home-destinations") {
                    Margin(top: 8.px)
                    RowGap(16.px)
                    ColumnGap(16.px)
                }
                Custom(".auth-home-destination") {
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
                Custom(".auth-home-destination h2, .auth-home-destination p") {
                    Margin(0)
                }
                Custom(".auth-home-destination h2 + p") {
                    Margin(top: (-6).px)
                }
                Custom(".auth-home-destination p") {
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    LineHeight(1.5)
                }
                Custom(".auth-home-destination .admin-button") {
                    Margin(top: 4.px)
                }
            }
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Auth",
                            description:
                                "Manage authentication, credentials, and access control."
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
                        .class("auth-home-destination")
                    }
                }
                .class("grid grid-221 auth-home-destinations")
            }
            .class("cms-section")
        }
    }
}
