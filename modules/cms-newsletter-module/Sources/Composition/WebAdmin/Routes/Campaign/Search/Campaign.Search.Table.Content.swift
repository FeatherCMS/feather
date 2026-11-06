import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Search.Table {
    struct Content: Component {
        let items: [Campaign.Search.Item]
        let pageState: AdminListPageState
        let search: String?
        let actions: AdminListActions
        let isPicker: Bool
        let routes: Campaign.Router.Routes

        private var searchValue: String { search ?? "" }

        private var returnTo: String {
            AdminLocation.url(
                path: routes.list.path,
                page: pageState.page,
                search: search
            )
        }

        func html(context: inout BuilderContext) -> Div {
            let canDelete = actions.allows(Campaign.Permissions.delete)
            let hasActiveQuery = !searchValue.isEmpty

            return context.build(
                AdminList(
                    table: {
                        if pageState.isPageOutOfRange {
                            context.build(
                                AdminListInvalidPageState(
                                    pageState: pageState,
                                    path: routes.list.path
                                )
                            )
                        }
                        else if items.isEmpty {
                            if hasActiveQuery {
                                context.build(
                                    AdminListNoResultsState(
                                        message:
                                            "No campaigns match your search.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.build(
                                                AdminButton(
                                                    "Reset search",
                                                    href: routes.list.path,
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
                                        message: "No campaigns yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if actions.allows(
                                                Campaign.Permissions.create
                                            ) && !isPicker {
                                                context.build(
                                                    AdminButton(
                                                        "Add new",
                                                        href: routes.add.path
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
                                            path: routes.removeSelected.path,
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
                                                name: "newsletter-campaigns",
                                                columns: isPicker
                                                    ? [
                                                        .fraction(1),
                                                        .fraction(2),
                                                        .actions,
                                                    ]
                                                    : [
                                                        .fraction(1),
                                                        .fraction(2),
                                                        .fraction(1),
                                                        .fraction(1),
                                                        .actions,
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
                                                        Th("Key")
                                                        Th("Name")
                                                        if !isPicker {
                                                            Th("Subscribers")
                                                            Th("Issues sent")
                                                        }
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for item in items {
                                                        context.build(
                                                            Row(
                                                                item: item,
                                                                actions:
                                                                    actions,
                                                                returnTo:
                                                                    returnTo,
                                                                isPicker:
                                                                    isPicker,
                                                                routes: routes
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
                                    action: routes.list.path,
                                    placeholder: "Quick search campaigns",
                                    search: searchValue
                                )
                            )
                        )
                    },
                    toolbar: {
                        if actions.allows(Campaign.Permissions.create)
                            && !isPicker
                        {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
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
                                    path: routes.list.path,
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
