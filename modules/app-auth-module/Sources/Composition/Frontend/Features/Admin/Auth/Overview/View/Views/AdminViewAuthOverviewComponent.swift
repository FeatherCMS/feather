import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewAuthOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Emails",
            description: "Manage email addresses and verification state.",
            href: AuthEmailRoutes.list.description + "/",
            icon: "mail"
        ),
        Destination(
            title: "Credentials",
            description: "Manage password credentials for user identities.",
            href: AuthCredentialRoutes.list.description + "/",
            icon: "key"
        ),
        Destination(
            title: "Magic links",
            description: "Manage passwordless sign-in links.",
            href: AuthMagicLinkRoutes.list.description + "/",
            icon: "link"
        ),
        Destination(
            title: "Access control",
            description: "Configure roles and authentication permissions.",
            href: AuthAccessControlRoutes.accessControl.description + "/",
            icon: "lock"
        ),
    ]

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
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
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
            Custom(".auth-home-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                NewAdminBreadcrumb(links: [
                    .init(label: "Admin", link: "/admin/")
                ])
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Auth",
                        description:
                            "Manage authentication, credentials, and access control."
                    )
                )
            )
            Div {
                for destination in destinations {
                    Div {
                        if let icon = FeatherIcons.get(named: destination.icon)
                        {
                            icon
                        }
                        H2(destination.title)
                        P(destination.description)
                        context.build(
                            NewAdminButton(
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
