import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewAnalyticsOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Web",
            description:
                "Explore audience, referrers, browsers, regions, and top pages.",
            href: "/admin/analytics/web/",
            icon: "monitor"
        ),
        Destination(
            title: "API",
            description:
                "Explore request volume, status families, paths, and methods.",
            href: "/admin/analytics/api/",
            icon: "server"
        ),
        Destination(
            title: "Logs",
            description: "Browse the tracked request log records directly.",
            href: "/admin/analytics/logs/",
            icon: "activity"
        ),
        Destination(
            title: "404s",
            description: "Inspect requests that could not be found.",
            href: "/admin/analytics/not-found/",
            icon: "alertCircle"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".analytics-overview-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".analytics-overview-destination") {
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
            Custom(
                ".analytics-overview-destination h2, .analytics-overview-destination p"
            ) { Margin(0) }
            Custom(".analytics-overview-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".analytics-overview-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".analytics-overview-destination .new-admin-button") {
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
                        title: "Analytics",
                        description:
                            "Explore web, API, log, and not-found analytics."
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
                    .class("analytics-overview-destination")
                }
            }
            .class("grid grid-221 analytics-overview-destinations")
        }
        .class("cms-section")
    }
}
