import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.Search.Table {
    struct Content: Component {
        let newsletterId: String
        let items: [Issue.Search.Item]
        let pageState: AdminListPageState
        let permissions: AdminListActions
        let search: String?
        let routes: Campaign.Router.Routes

        private var path: String {
            routes.issuesPath(newsletterId: newsletterId)
        }

        private var searchValue: String { search ?? "" }

        private var returnTo: String {
            AdminLocation.url(path: path, page: pageState.page, search: search)
        }

        func html(context: inout BuilderContext) -> Div {
            let canCreate = permissions.allows(Issue.Permissions.create)
            let hasActiveQuery = !searchValue.isEmpty

            return context.build(
                AdminList(
                    table: {
                        if pageState.isPageOutOfRange {
                            context.build(
                                AdminListInvalidPageState(
                                    pageState: pageState,
                                    path: path
                                )
                            )
                        }
                        else if items.isEmpty {
                            if hasActiveQuery {
                                context.build(
                                    AdminListNoResultsState(
                                        message: "No issues match your search.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.build(
                                                AdminButton(
                                                    "Reset search",
                                                    href: path,
                                                    style: .secondary
                                                )
                                            )
                                        }
                                    )
                                )
                            }
                            else {
                                context.build(
                                    AdminListEmptyState(
                                        message: "No issues yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if canCreate {
                                                context.build(
                                                    AdminButton(
                                                        "Add new",
                                                        href:
                                                            routes.issueAddPath(
                                                                newsletterId:
                                                                    newsletterId
                                                            )
                                                    )
                                                )
                                            }
                                        }
                                    )
                                )
                            }
                        }
                        else {
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: AdminLocation.remove(
                                            path: routes
                                                .issueRemoveSelectedPath(
                                                    newsletterId: newsletterId
                                                ),
                                            ids: [],
                                            returnTo: returnTo
                                        ),
                                        pageState: pageState,
                                        search: searchValue,
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: permissions.allows(
                                            Issue.Permissions.delete
                                        )
                                    ),
                                    table: context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "newsletter-issues",
                                                columns: [
                                                    .fraction(2), .fraction(1),
                                                    .fraction(2), .fraction(1),
                                                    .fraction(1), .actions,
                                                ]
                                            ),
                                            hasSelection: permissions.allows(
                                                Issue.Permissions.delete
                                            ),
                                            table: Table {
                                                Thead {
                                                    Tr {
                                                        if permissions.allows(
                                                            Issue.Permissions
                                                                .delete
                                                        ) {
                                                            context.build(
                                                                AdminListSelectAllCheckbox()
                                                            )
                                                        }
                                                        Th("Subject")
                                                        Th("Status")
                                                        Th("Delivery")
                                                        Th("Scheduled")
                                                        Th("Created")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for item in items {
                                                        context.build(
                                                            Issue.Search.Row(
                                                                newsletterId:
                                                                    newsletterId,
                                                                item: item,
                                                                permissions:
                                                                    permissions,
                                                                routes: routes
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                            .class("cms-table", "action-table")
                                            .if(permissions.allows(
                                                Issue.Permissions.delete
                                            )) {
                                                $0.class("select-table")
                                            }
                                        )
                                    )
                                )
                            )
                        }
                    },
                    search: {
                        context.build(
                            AdminListSearch(
                                state: .init(
                                    action: path,
                                    placeholder: "Quick search issues",
                                    search: searchValue
                                )
                            )
                        )
                    },
                    toolbar: {
                        if canCreate {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
                                            href: routes.issueAddPath(
                                                newsletterId: newsletterId
                                            )
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
                                    pageState: pageState,
                                    search: searchValue
                                )
                            )
                        )
                    }
                )
            )
        }
    }
}
