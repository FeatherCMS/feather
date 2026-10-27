import CSS
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension Overview {
    struct Component: WebComponents.Component {
        let routes: Router.Routes

        private var destinations: [Destination] {
            [
                Destination(
                    title: "Campaigns",
                    description:
                        "Manage newsletter campaigns and their issues.",
                    href: routes.campaigns.path,
                    icon: "send"
                ),
            ]
        }

        func rules() -> [any Rule] {
            Media {
                Custom(".newsletter-overview-destinations") {
                    Margin(top: 8.px)
                    RowGap(16.px)
                    ColumnGap(16.px)
                }
                Custom(".newsletter-overview-destination") {
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
                    ".newsletter-overview-destination h2, .newsletter-overview-destination p"
                ) { Margin(0) }
                Custom(".newsletter-overview-destination h2 + p") {
                    Margin(top: (-6).px)
                }
                Custom(".newsletter-overview-destination p") {
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    LineHeight(1.5)
                }
                Custom(".newsletter-overview-destination .admin-button") {
                    Margin(top: 4.px)
                }
            }
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: [
                        .init(
                            label: "Admin",
                            link: routes.admin.path
                        )
                    ])
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Newsletter",
                            description:
                                "Manage newsletter campaigns and their issues."
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
                        .class("newsletter-overview-destination")
                    }
                }
                .class("grid grid-221 newsletter-overview-destinations")
            }
            .class("cms-section")
        }
    }
}
