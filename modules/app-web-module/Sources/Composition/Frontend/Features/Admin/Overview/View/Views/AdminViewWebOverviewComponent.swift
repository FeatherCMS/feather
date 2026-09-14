import CSS
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Pages",
            description: "Manage the web pages published by the application.",
            href: WebPageRoutes.list.description,
            icon: "fileText"
        ),
        Destination(
            title: "Menus",
            description: "Manage navigation menus and their items.",
            href: WebMenuRoutes.list.description,
            icon: "menu"
        ),
        Destination(
            title: "Metadata",
            description: "Manage web routes and page metadata.",
            href: WebMetadataRoutes.list.description,
            icon: "tag"
        ),
        Destination(
            title: "Settings",
            description: "Manage the public web settings.",
            href: WebSettingsRoutes.edit.description,
            icon: "settings"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".web-home-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".web-home-destination") {
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
            Custom(".web-home-destination h2, .web-home-destination p") {
                Margin(0)
            }
            Custom(".web-home-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".web-home-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".web-home-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(
                    links: [
                        .init(label: "Admin", link: "/admin/")
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Web",
                        description:
                            "Manage pages, menus, metadata, and web settings."
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
                    .class("web-home-destination")
                }
            }
            .class("grid grid-221 web-home-destinations")
        }
        .class("cms-section")
    }
}
