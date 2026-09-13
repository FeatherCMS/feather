import CSS
import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct AdminGetAuthOverviewComponent: Component {
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
            href: "/admin/auth/emails/",
            icon: "mail"
        ),
        Destination(
            title: "Credentials",
            description: "Manage password credentials for user identities.",
            href: "/admin/auth/credentials/",
            icon: "key"
        ),
        Destination(
            title: "Magic links",
            description: "Manage passwordless sign-in links.",
            href: "/admin/auth/magic-links/",
            icon: "link"
        ),
        Destination(
            title: "Access control",
            description: "Configure roles and authentication permissions.",
            href: "/admin/auth/access-control/",
            icon: "lock"
        ),
        Destination(
            title: "Profile",
            description:
                "Inspect and update the current administrator profile.",
            href: "/admin/auth/profile/",
            icon: "user"
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

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: [
                    .init(label: "Admin", link: "/admin/")
                ])
            )
            context.render(
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
                        context.render(
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
