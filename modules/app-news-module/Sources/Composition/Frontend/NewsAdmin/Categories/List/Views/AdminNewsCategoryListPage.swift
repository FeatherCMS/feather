import FeatherAdmin
import FeatherModuleKit
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
    let permissions: AdminListActions
    let canAccess: Bool

    func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        let path = NewsAdminRoutes.categories.description + "/"
        return Section {
            context.build(
                AdminBreadcrumb(links: NewsAdminRoutes.categoriesBreadcrumb)
            )
            if canAccess {
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "News categories",
                            description: "Manage news categories."
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
                                            ? "No news categories yet."
                                            : "No news categories match your search.",
                                        icon: FeatherIcons.inbox()
                                    )
                                )
                            }
                            else {
                                context.build(
                                    AdminListShell(
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
                                    AdminListToolbar {
                                        context.build(
                                            AdminButton(
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
