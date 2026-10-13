import FeatherAdmin
import FeatherContracts
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
    let permissions: NewAdminListActions
    let canAccess: Bool

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        let path = NewsAdminRoutes.articles.description + "/"
        return Section {
            context.build(
                NewAdminBreadcrumb(links: NewsAdminRoutes.articlesBreadcrumb)
            )
            if canAccess {
                context.build(
                    NewAdminPageHeader(
                        state: .primary(
                            title: "News articles",
                            description: "Manage news articles."
                        )
                    )
                )
                if let error {
                    P(error).class("new-admin-form__error")
                }
                context.build(
                    NewAdminList(
                        table: {
                            if model.items.isEmpty {
                                context.build(
                                    NewAdminListEmptyState(
                                        message: search.isEmpty
                                            ? "No news articles yet."
                                            : "No news articles match your search.",
                                        icon: FeatherIcons.inbox()
                                    )
                                )
                            }
                            else {
                                context.build(
                                    NewAdminListShell(
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
                                                        Td(item.excerpt)
                                                            .data(
                                                                "label",
                                                                "Excerpt"
                                                            )
                                                        context.build(
                                                            NewAdminListRowActions(
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
                                                                    .init(
                                                                        "Remove",
                                                                        href:
                                                                            NewsAdminRoutes
                                                                            .articleRemove(
                                                                                RouterPath(
                                                                                    item
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .description
                                                                            + "/",
                                                                        style:
                                                                            .destructive,
                                                                        permission:
                                                                            NewsPermissions
                                                                            .Articles
                                                                            .delete
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
                                NewAdminListSearch(
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
                                    NewAdminListToolbar {
                                        context.build(
                                            NewAdminButton(
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
                                NewAdminListPagination(
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
                    NewAdminStatusView(
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
