import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignsTableContent: Component {
    let items: [AdminNewsletterCampaignItem]
    let pageState: NewAdminListPageState
    let search: String?
    let actions: NewAdminListActions
    let isPicker: Bool

    private var searchValue: String { search ?? "" }

    private var returnTo: String {
        NewAdminLocation.url(
            path: NewsletterAdminRoutes.campaigns.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = actions.allows(Permissions.Campaigns.delete)
        let hasActiveQuery = !searchValue.isEmpty

        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: NewsletterAdminRoutes.campaigns
                                    .description
                            )
                        )
                    }
                    else if items.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message: "No campaigns match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            NewAdminButton(
                                                "Reset search",
                                                href: NewsletterAdminRoutes
                                                    .campaigns.description,
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
                                    message: "No campaigns yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if actions.allows(
                                            Permissions.Campaigns.create
                                        ) && !isPicker {
                                            context.build(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: NewsletterAdminRoutes
                                                        .campaignAdd.description
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
                                        path: NewsletterAdminRoutes
                                            .campaignRemove.description,
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
                                            name: "newsletter-campaigns",
                                            columns: [
                                                .fraction(1),
                                                .fraction(2),
                                                .fixed(240),
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
                                                    Th("Key")
                                                    Th("Name")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    context.build(
                                                        NewsletterCampaignRow(
                                                            item: item,
                                                            actions: actions,
                                                            returnTo: returnTo,
                                                            isPicker: isPicker
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
                                action: NewsletterAdminRoutes.campaigns
                                    .description,
                                placeholder: "Quick search campaigns",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if actions.allows(Permissions.Campaigns.create) && !isPicker
                    {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add new",
                                        href: NewsletterAdminRoutes.campaignAdd
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
                                path: NewsletterAdminRoutes.campaigns
                                    .description,
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
