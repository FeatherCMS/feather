import FeatherAdmin
import FeatherContracts
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

    func html(context: inout RenderContext) -> Div {
        let canDelete = actions.allows(Permissions.Campaigns.delete)
        let hasActiveQuery = !searchValue.isEmpty

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: NewsletterAdminRoutes.campaigns
                                    .description
                            )
                        )
                    }
                    else if items.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message: "No campaigns match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
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
                            context.render(
                                NewAdminListEmptyState(
                                    message: "No campaigns yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if actions.allows(
                                            Permissions.Campaigns.create
                                        ) && !isPicker {
                                            context.render(
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
                        context.render(
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
                                table: context.render(
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
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("ID")
                                                    Th("Name")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    context.render(
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
                    context.render(
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
                        context.render(
                            NewAdminListToolbar {
                                context.render(
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
                    context.render(
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
