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

    func html(context: inout RenderContext) -> Div {
        let canCreate = permissions.allows(Permissions.Issues.create)
        let hasActiveQuery = !searchValue.isEmpty

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: path
                            )
                        )
                    }
                    else if items.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message: "No issues match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
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
                            context.render(
                                NewAdminListEmptyState(
                                    message: "No issues yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.render(
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
                        context.render(
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
                                            context.render(
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
                    context.render(
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
                        context.render(
                            NewAdminListToolbar {
                                context.render(
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
                    context.render(
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
