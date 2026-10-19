import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import NewsContracts
import SGML
import WebBuilders
import WebComponents

struct AdminNewsArticleListPage: Component {
    let model: AdminNewsArticleListModel
    let search: String
    let error: String?
    let permissions: AdminListActions
    let canAccess: Bool

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        let path = NewsAdminRoutes.articles.description + "/"
        return Section {
            context.build(
                AdminBreadcrumb(links: NewsAdminRoutes.articlesBreadcrumb)
            )
            if canAccess {
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "News articles",
                            description: "Manage news articles."
                        )
                    )
                )
                if let error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminList(
                        table: {
                            if model.items.isEmpty {
                                context.build(
                                    AdminListEmptyState(
                                        message: search.isEmpty
                                            ? "No news articles yet."
                                            : "No news articles match your search.",
                                        icon: FeatherIcons.inbox()
                                    )
                                )
                            }
                            else {
                                context.build(
                                    AdminListShell(
                                        layout: .init(
                                            name: "news-articles",
                                            columns: [
                                                .fraction(1), .fraction(1),
                                                .fixed(220),
                                            ]
                                        ),
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    Th("Title")
                                                    Th("Excerpt")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in model.items {
                                                    Tr {
                                                        Td(item.title)
                                                            .data(
                                                                "label",
                                                                "Title"
                                                            )
                                                            .data(
                                                                "remove-label",
                                                                "true"
                                                            )
                                                        Td(item.excerpt)
                                                            .data(
                                                                "label",
                                                                "Excerpt"
                                                            )
                                                        context.build(
                                                            AdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "View",
                                                                        href:
                                                                            NewsAdminRoutes
                                                                            .article(
                                                                                RouterPath(
                                                                                    item
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .description
                                                                            + "/",
                                                                        style:
                                                                            .ghost(
                                                                                .primary
                                                                            ),
                                                                        permission:
                                                                            NewsPermissions
                                                                            .Articles
                                                                            .read
                                                                    ),
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            NewsAdminRoutes
                                                                            .articleEdit(
                                                                                RouterPath(
                                                                                    item
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .description
                                                                            + "/",
                                                                        style:
                                                                            .ghost(
                                                                                .secondary
                                                                            ),
                                                                        permission:
                                                                            NewsPermissions
                                                                            .Articles
                                                                            .update
                                                                    ),
                                                                ],
                                                                permissions:
                                                                    permissions
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                    )
                                )
                            }
                        },
                        search: {
                            context.build(
                                AdminListSearch(
                                    state: .init(
                                        action: path,
                                        placeholder: "Search news articles...",
                                        search: search
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if permissions.allows(
                                NewsPermissions.Articles.create
                            ) {
                                context.build(
                                    AdminListToolbar {
                                        context.build(
                                            AdminButton(
                                                "Add article",
                                                href:
                                                    NewsAdminRoutes.articleAdd()
                                                    .description + "/"
                                            )
                                        )
                                    }
                                )
                            }
                        },
                        pagination: {
                            context.build(
                                AdminListPagination(
                                    state: .init(
                                        path: path,
                                        pageState: .init(
                                            page: model.page,
                                            pageSize: model.pageSize,
                                            total: model.total
                                        ),
                                        search: search
                                    )
                                )
                            )
                        }
                    )
                )
            }
            else {
                context.build(
                    AdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message: "Your account cannot access news articles."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
        }
        .class("cms-section")
    }
}
