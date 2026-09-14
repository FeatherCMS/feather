import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMenuTableContent: Component {
    let menus: [Components.Schemas.WebMenuListItemSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var searchValue: String { search ?? "" }

    private var returnTo: String {
        NewAdminLocation.url(
            path: WebMenuRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(WebPermissions.Menus.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: WebMenuRoutes.list.description
                            )
                        )
                    }
                    else if menus.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message: "No menus match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: WebMenuRoutes.list.description,
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
                                    message: "No menus yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(WebPermissions.Menus.create) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: WebMenuRoutes.add.description
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
                                    action: WebMenuRoutes.remove.description,
                                    pageState: pageState,
                                    search: searchValue,
                                    button: .init("Remove selected", style: .destructive),
                                    isEnabled: canDelete
                                ),
                                table: context.render(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "web-menus",
                                            columns: [.fraction(1), .fraction(2), .fixed(220)]
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete { context.render(NewAdminListSelectAllCheckbox()) }
                                                    Th("Key")
                                                    Th("Name")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for menu in menus {
                                                    context.render(
                                                        WebMenuRow(
                                                            menu: menu,
                                                            permissions: permissions,
                                                            returnTo: returnTo
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                        .if(canDelete) { $0.class("select-table") }
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
                                action: WebMenuRoutes.list.description,
                                placeholder: "Quick search menus",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(WebPermissions.Menus.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(NewAdminButton("Add new", href: WebMenuRoutes.add.description))
                            }
                        )
                    }
                },
                pagination: {
                    context.render(
                        NewAdminListPagination(
                            state: .init(
                                path: WebMenuRoutes.list.description,
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
