import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import WebBuilders
import WebComponents

struct NewsletterIssuesTableContent: Component {
    let newsletterId: String
    let items: [AdminNewsletterIssueItem]
    let pageState: NewAdminListPageState
    let permissions: NewAdminListActions
    let search: String?

    private var path: String {
        NewsletterAdminRoutes.campaignIssues(RouterPath(newsletterId))
            .description
    }

    private var searchValue: String { search ?? "" }

    func html(context: inout BuilderContext) -> Div {
        let canCreate = permissions.allows(Permissions.Issues.create)
        let hasActiveQuery = !searchValue.isEmpty

        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: path
                            )
                        )
                    }
                    else if items.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message: "No issues match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            NewAdminButton(
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
                                NewAdminListEmptyState(
                                    message: "No issues yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.build(
                                                NewAdminButton(
                                                    "Add new",
                                                    href:
                                                        NewsletterAdminRoutes
                                                        .issueAdd(
                                                            RouterPath(
                                                                newsletterId
                                                            )
                                                        )
                                                        .description
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
                            NewAdminListShell(
                                layout: .init(
                                    name: "newsletter-issues",
                                    columns: [
                                        .fraction(2), .fraction(1),
                                        .fraction(1), .fraction(1), .fixed(240),
                                    ]
                                ),
                                hasSelection: false,
                                table: Table {
                                    Thead {
                                        Tr {
                                            Th("Subject")
                                            Th("Status")
                                            Th("Scheduled")
                                            Th("Created")
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for item in items {
                                            context.build(
                                                NewsletterIssueRow(
                                                    newsletterId: newsletterId,
                                                    item: item,
                                                    permissions: permissions
                                                )
                                            )
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
                                placeholder: "Quick search issues",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if canCreate {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add new",
                                        href:
                                            NewsletterAdminRoutes.issueAdd(
                                                RouterPath(newsletterId)
                                            )
                                            .description
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
