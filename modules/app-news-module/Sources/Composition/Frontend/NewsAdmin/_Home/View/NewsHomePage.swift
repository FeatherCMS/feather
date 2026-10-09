import CSS
import FeatherAdmin
import HTML
import Hummingbird
import NewsContracts
import WebBuilders
import WebComponents

struct NewsHomePage: Component {
    let canViewArticles: Bool
    let canViewCategories: Bool

    func rules() -> [any Rule] {
        Media {
            Custom(".news-overview-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".news-overview-destination") {
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
                ".news-overview-destination h2, .news-overview-destination p"
            ) {
                Margin(0)
            }
            Custom(".news-overview-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".news-overview-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".news-overview-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(
        context: inout BuilderContext
    ) -> Section {
        Section {
            context.build(NewAdminBreadcrumb(links: NewsAdminRoutes.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .primary(
                        title: "News",
                        description: "Manage articles and categories."
                    )
                )
            )
            if canViewArticles || canViewCategories {
                Div {
                    if canViewArticles {
                        Div {
                            if let icon = FeatherIcons.get(named: "fileText") {
                                icon
                            }
                            H2("Articles")
                            P("Create and manage news articles.")
                            context.build(
                                NewAdminButton(
                                    "Open",
                                    href: NewsAdminRoutes.articles.description
                                        + "/",
                                    style: .primary
                                )
                            )
                        }
                        .class("news-overview-destination")
                    }
                    if canViewCategories {
                        Div {
                            if let icon = FeatherIcons.get(named: "tag") {
                                icon
                            }
                            H2("Categories")
                            P("Organize news articles into categories.")
                            context.build(
                                NewAdminButton(
                                    "Open",
                                    href: NewsAdminRoutes.categories.description
                                        + "/",
                                    style: .primary
                                )
                            )
                        }
                        .class("news-overview-destination")
                    }
                }
                .class("grid grid-221 news-overview-destinations")
            }
            else {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message: "Your account cannot access news."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
        }
        .class("cms-section")
    }
}
