import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewMediaOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Assets",
            description: "Manage uploaded media assets and folders.",
            href: MediaAssetRoutes.list.description,
            icon: "folder"
        ),
        Destination(
            title: "Variants",
            description:
                "Manage variants and their source-specific processor rules.",
            href: MediaVariantRoutes.list.description,
            icon: "crop"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".media-overview-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".media-overview-destination") {
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
                ".media-overview-destination h2, .media-overview-destination p"
            ) { Margin(0) }
            Custom(".media-overview-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".media-overview-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".media-overview-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                NewAdminBreadcrumb(links: MediaAdminRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Media",
                        description:
                            "Manage media assets, folders, and variants."
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
                    .class("media-overview-destination")
                }
            }
            .class("grid grid-221 media-overview-destinations")
        }
        .class("cms-section")
    }
}
