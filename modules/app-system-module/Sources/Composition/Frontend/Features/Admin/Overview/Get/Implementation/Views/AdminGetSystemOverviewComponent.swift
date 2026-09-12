import CSS
import FeatherAdmin
import Hummingbird
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetSystemOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }
    private let destinations = [
        Destination(
            title: "Variables",
            description: "Manage application configuration values.",
            href: "/admin/system/variables/",
            icon: "sliders"
        ),
        Destination(
            title: "Permissions",
            description: "Manage system access permissions.",
            href: SystemPermissionRoutes.list.description,
            icon: "lock"
        ),
        Destination(
            title: "Worker jobs",
            description: "Inspect queued and completed background jobs.",
            href: "/admin/system/jobs/",
            icon: "activity"
        ),
        Destination(
            title: "Design system",
            description:
                "Explore the admin interface materials and components.",
            href: "/admin/system/design-system/",
            icon: "layers"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".system-home-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".system-home-destination") {
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
            Custom(".system-home-destination h2, .system-home-destination p") {
                Margin(0)
            }
            Custom(".system-home-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".system-home-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".system-home-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(
                    state: .init(links: [
                        .init(label: "Admin", link: "/admin/")
                    ])
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "System",
                        description:
                            "Manage core system configuration and administration tools."
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
                    .class("system-home-destination")
                }
            }
            .class("grid grid-221 system-home-destinations")
        }
        .class("cms-section")
    }
}
