import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

struct WebMenuTableContent: Component {
    let menus: [Components.Schemas.WebMenuQueryItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?

    private var searchValue: String { search ?? "" }

    private var returnTo: String {
        AdminLocation.url(
            path: WebMenuRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(WebModule.Permissions.Menus.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: WebMenuRoutes.list.description
                            )
                        )
                    }
                    else if menus.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message: "No menus match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: WebMenuRoutes.list
                                                    .description,
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
                                    message: "No menus yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            WebModule.Permissions.Menus.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: WebMenuRoutes.add
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
                                    action: WebMenuRoutes.remove.description,
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
                                            name: "web-menus",
                                            columns: [
                                                .fraction(1), .fraction(2),
                                                .fixed(220),
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
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for menu in menus {
                                                    context.build(
                                                        WebMenuRow(
                                                            menu: menu,
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
                                action: WebMenuRoutes.list.description,
                                placeholder: "Quick search menus",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(WebModule.Permissions.Menus.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: WebMenuRoutes.add.description
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
