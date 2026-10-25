import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsApplication
import NewsModule
import SGML
import WebBuilders
import WebComponents

extension NewsModule.Article.List {
    struct Page: Component {
        let model: Model
        let search: String
        let error: String?
        let permissions: AdminListActions
        let canAccess: Bool
        let routes: NewsModule.Article.Router.Routes

        func html(
            context: inout BuilderContext
        ) -> some BasicTag {
            let path = routes.list.path
            return Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
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
                                                    .actions,
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
                                                                .setAsRemoveConfirmationLabel()
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
                                                                                routes
                                                                                .detailsPath(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                NewsModule
                                                                                .Article
                                                                                .Permissions
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                routes
                                                                                .editPath(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                NewsModule
                                                                                .Article
                                                                                .Permissions
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
                                                "Search news articles...",
                                            search: search
                                        )
                                    )
                                )
                            },
                            toolbar: {
                                if permissions.allows(
                                    NewsModule.Article.Permissions.create
                                ) {
                                    context.build(
                                        AdminListToolbar {
                                            context.build(
                                                AdminButton(
                                                    "Add article",
                                                    href: routes.add.path
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
                                    "Your account cannot access news articles."
                            ),
                            icon: FeatherIcons.alertCircle()
                        )
                    )
                }
            }
            .class("cms-section")
        }
    }
}
