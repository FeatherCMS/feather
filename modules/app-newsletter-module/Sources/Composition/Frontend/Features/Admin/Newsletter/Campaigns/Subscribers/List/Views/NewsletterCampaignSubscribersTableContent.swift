import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscribersTableContent: Component {
    let newsletterId: String
    let items: [AdminNewsletterCampaignSubscriberItem]
    let pageState: NewAdminListPageState
    let search: String?
    let permissions: NewAdminListActions

    private var path: String {
        NewsletterAdminRoutes.campaignSubscribers(RouterPath(newsletterId))
            .description
    }

    private var searchValue: String { search ?? "" }

    private var returnTo: String {
        NewAdminLocation.url(path: path, page: pageState.page, search: search)
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(Permissions.Subscribers.delete)
        let canCreate = permissions.allows(Permissions.Subscribers.create)
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
                                    message:
                                        "No subscribers match your search.",
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
                                    message: "No subscribers yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.build(
                                                NewAdminButton(
                                                    "Add new",
                                                    href:
                                                        NewsletterAdminRoutes
                                                        .campaignSubscriberAdd(
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
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path:
                                            NewsletterAdminRoutes
                                            .campaignSubscriberRemoveSelected(
                                                RouterPath(newsletterId)
                                            )
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: pageState,
                                    search: searchValue,
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.build(
                                    NewAdminListShell(
                                        layout: .init(
                                            name:
                                                "newsletter-campaign-subscribers",
                                            columns: [
                                                .fraction(2), .fraction(2),
                                                .fraction(1), .fixed(240),
                                            ]
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.build(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("Email")
                                                    Th("Name")
                                                    Th("Status")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    context.build(
                                                        NewsletterCampaignSubscriberRow(
                                                            newsletterId:
                                                                newsletterId,
                                                            item: item,
                                                            permissions:
                                                                permissions
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                        .if(canDelete) {
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
                        NewAdminListSearch(
                            state: .init(
                                action: path,
                                placeholder: "Quick search subscribers",
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
                                            NewsletterAdminRoutes
                                            .campaignSubscriberAdd(
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
