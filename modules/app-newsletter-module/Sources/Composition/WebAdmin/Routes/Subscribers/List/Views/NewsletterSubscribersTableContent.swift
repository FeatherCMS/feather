import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

struct NewsletterSubscribersTableContent: Component {
    let model: AdminNewsletterSubscribersListModel
    let permissions: AdminListActions

    private var path: String { NewsletterAdminRoutes.subscribers.description }
    private var searchValue: String { model.search }
    private var locationQueryItems: [(String, String)] {
        model.campaignId.isEmpty ? [] : [("campaignId", model.campaignId)]
    }
    private var searchQueryItems: [AdminListSearch.QueryItem] {
        model.campaignId.isEmpty
            ? []
            : [.init(name: "campaignId", value: model.campaignId)]
    }
    private var paginationQueryItems: [AdminListPagination.QueryItem] {
        model.campaignId.isEmpty
            ? []
            : [.init(name: "campaignId", value: model.campaignId)]
    }
    private var returnTo: String {
        AdminLocation.url(
            path: path,
            page: model.pageState.page,
            search: searchValue,
            queryItems: locationQueryItems
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(Subscriber.Permissions.delete)
        let canCreate = permissions.allows(Subscriber.Permissions.create)
        let hasActiveQuery = !searchValue.isEmpty || !model.campaignId.isEmpty

        return context.build(
            AdminList(
                table: {
                    if model.pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: model.pageState,
                                path: path
                            )
                        )
                    }
                    else if model.items.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No subscribers match your filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
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
                            context.build(
                                AdminListEmptyState(
                                    message: "No subscribers yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if canCreate {
                                            context.build(
                                                AdminButton(
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
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
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
                                table: context.build(
                                    AdminListShell(
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
                                                        context.build(
                                                            AdminListSelectAllCheckbox()
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
                                                    context.build(
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
                    context.build(
                        AdminListSearch(
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
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
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
                    context.build(
                        AdminListPagination(
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
