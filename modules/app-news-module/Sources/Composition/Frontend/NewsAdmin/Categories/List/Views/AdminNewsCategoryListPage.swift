import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import NewsContracts
import SGML
import WebBuilders
import WebComponents

struct AdminNewsCategoryListPage: Component {
    let model: AdminNewsCategoryListModel
    let search: String
    let error: String?
    let permissions: NewAdminListActions
    let canAccess: Bool

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        let path = NewsAdminRoutes.categories.description + "/"
        return Section {
            context.build(
                NewAdminBreadcrumb(links: NewsAdminRoutes.categoriesBreadcrumb)
            )
            if canAccess {
                context.build(
                    NewAdminPageHeader(
                        state: .primary(
                            title: "News categories",
                            description: "Manage news categories."
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
                                            ? "No news categories yet."
                                            : "No news categories match your search.",
                                        icon: FeatherIcons.inbox()
                                    )
                                )
                            }
                            else {
                                context.build(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "news-categories",
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
                                                                            .category(
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
                                                                            .Categories
                                                                            .read
                                                                    ),
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            NewsAdminRoutes
                                                                            .categoryEdit(
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
                                                                            .Categories
                                                                            .update
                                                                    ),
                                                                    .init(
                                                                        "Remove",
                                                                        href:
                                                                            NewsAdminRoutes
                                                                            .categoryRemove(
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
                                                                            .Categories
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
                                        placeholder:
                                            "Search news categories...",
                                        search: search
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if permissions.allows(
                                NewsPermissions.Categories.create
                            ) {
                                context.build(
                                    NewAdminListToolbar {
                                        context.build(
                                            NewAdminButton(
                                                "Add category",
                                                href:
                                                    NewsAdminRoutes
                                                    .categoryAdd().description
                                                    + "/"
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
                            message:
                                "Your account cannot access news categories."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
        }
        .class("cms-section")
    }
}
