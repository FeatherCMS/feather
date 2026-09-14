import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTableContent: Component {
    let model: AdminNewsletterSubscribersListModel
    let permissions: NewAdminListActions

    private var path: String { NewsletterAdminRoutes.subscribers.description }
    private var searchValue: String { model.search }
    private var locationQueryItems: [(String, String)] {
        model.campaignId.isEmpty ? [] : [("campaignId", model.campaignId)]
    }
    private var searchQueryItems: [NewAdminListSearch.QueryItem] {
        model.campaignId.isEmpty
            ? []
            : [.init(name: "campaignId", value: model.campaignId)]
    }
    private var paginationQueryItems: [NewAdminListPagination.QueryItem] {
        model.campaignId.isEmpty
            ? []
            : [.init(name: "campaignId", value: model.campaignId)]
    }
    private var returnTo: String {
        NewAdminLocation.url(
            path: path,
            page: model.pageState.page,
            search: searchValue,
            queryItems: locationQueryItems
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(Permissions.Subscribers.delete)
        let canCreate = permissions.allows(Permissions.Subscribers.create)
        let hasActiveQuery = !searchValue.isEmpty || !model.campaignId.isEmpty

        return context.render(
            NewAdminList(
                table: {
                    if model.pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: model.pageState,
                                path: path
                            )
                        )
                    }
                    else if model.items.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message:
                                        "No subscribers match your filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset filters",
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
                                    message: "No subscribers yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: NewsletterAdminRoutes
                                                        .subscriberAdd
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
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path: NewsletterAdminRoutes
                                            .subscriberRemove.description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: model.pageState,
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
                                            name: "newsletter-subscribers",
                                            columns: [
                                                .fraction(2), .fraction(1),
                                                .fraction(2), .fixed(280),
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
                                                    Th("Email")
                                                    Th("Name")
                                                    Th("Campaigns")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in model.items {
                                                    context.render(
                                                        NewsletterSubscriberRow(
                                                            item: item,
                                                            permissions:
                                                                permissions,
                                                            returnTo: returnTo
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
                                action: path,
                                placeholder: "Quick search subscribers",
                                search: searchValue,
                                queryItems: searchQueryItems
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
                                        href: NewsletterAdminRoutes
                                            .subscriberAdd.description
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
                                pageState: model.pageState,
                                search: searchValue,
                                queryItems: paginationQueryItems
                            )
                        )
                    )
                }
            )
        )
    }
}
