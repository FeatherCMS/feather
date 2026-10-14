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
    let pageState: AdminListPageState
    let search: String?
    let permissions: AdminListActions

    private var path: String {
        NewsletterAdminRoutes.campaignSubscribers(RouterPath(newsletterId))
            .description
    }

    private var searchValue: String { search ?? "" }

    private var returnTo: String {
        AdminLocation.url(path: path, page: pageState.page, search: search)
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(Permissions.Subscribers.delete)
        let canCreate = permissions.allows(Permissions.Subscribers.create)
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
                                    message:
                                        "No subscribers match your search.",
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
                                    message: "No subscribers yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.build(
                                                AdminButton(
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
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
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
                                    AdminListShell(
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
                                                            AdminListSelectAllCheckbox()
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
                        AdminListSearch(
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
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
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
