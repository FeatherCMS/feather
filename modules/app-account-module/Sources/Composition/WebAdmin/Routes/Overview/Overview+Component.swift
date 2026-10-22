import AccountModule
import CSS
import FeatherWebAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension Overview {

    struct Component: WebComponents.Component {
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
                    title: "Profile",
                    description: "Manage your account profile and image.",
                    href: routes.profile.path,
                    icon: "user"
                ),
                Destination(
                    title: "Settings",
                    description: "Manage account preferences and settings.",
                    href: routes.settings.path,
                    icon: "settings"
                ),
                Destination(
                    title: "Invitations",
                    description: "Manage invitations sent to your account.",
                    href: routes.invitations.path,
                    icon: "mail"
                ),
            ]
        }

        func rules() -> [any Rule] {
            Media {
                Custom(".account-overview-destinations") {
                    Margin(top: 8.px)
                    RowGap(16.px)
                    ColumnGap(16.px)
                }
                Custom(".account-overview-destination") {
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
                    ".account-overview-destination h2, .account-overview-destination p"
                ) { Margin(0) }
                Custom(".account-overview-destination h2 + p") {
                    Margin(top: (-6).px)
                }
                Custom(".account-overview-destination p") {
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    LineHeight(1.5)
                }
                Custom(".account-overview-destination .admin-button") {
                    Margin(top: 4.px)
                }
            }
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: [
                        .init(label: "Admin", link: "/admin/")
                    ])
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Account",
                            description:
                                "Manage your profile, settings, and invitations."
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
                        .class("account-overview-destination")
                    }
                }
                .class("grid grid-221 account-overview-destinations")
            }
            .class("cms-section")
        }
    }
}
