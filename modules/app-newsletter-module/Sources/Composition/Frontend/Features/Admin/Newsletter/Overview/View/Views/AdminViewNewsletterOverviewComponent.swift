import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewNewsletterOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Campaigns",
            description: "Manage newsletter campaigns and their issues.",
            href: NewsletterAdminRoutes.campaigns.description,
            icon: "send"
        ),
        Destination(
            title: "Subscribers",
            description: "Manage newsletter subscribers and subscriptions.",
            href: NewsletterAdminRoutes.subscribers.description,
            icon: "users"
        ),
    ]

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
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
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
            Custom(".newsletter-overview-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                NewAdminBreadcrumb(links: [
                    .init(
                        label: "Admin",
                        link: NewsletterAdminRoutes.admin.description + "/"
                    )
                ])
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Newsletter",
                        description:
                            "Manage newsletter campaigns and subscribers."
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
                    .class("newsletter-overview-destination")
                }
            }
            .class("grid grid-221 newsletter-overview-destinations")
        }
        .class("cms-section")
    }
}
