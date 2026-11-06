import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Menu.List.Page {
    struct Content: WebComponents.Component {
        let menus: [Components.Schemas.MenuQueryItemSchema]
        let permissions: AdminListActions
        let pageState: AdminListPageState
        let search: String?
        let routes: WebModule.Menu.Router.Routes

        private var searchValue: String { search ?? "" }

        private var returnTo: String {
            AdminLocation.url(
                path: routes.list.path,
                page: pageState.page,
                search: search
            )
        }

        func html(context: inout BuilderContext) -> Div {
            let canDelete = permissions.allows(
                Menu.Permissions.delete
            )
            let hasActiveQuery = !(search?.isEmpty ?? true)

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
                                        message: "No menus yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if permissions.allows(
                                                Menu.Permissions
                                                    .create
                                            ) {
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
                                        action: routes.remove.path,
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
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for menu in menus {
                                                        context.build(
                                                            Menu.List.Row(
                                                                menu: menu,
                                                                permissions:
                                                                    permissions,
                                                                returnTo:
                                                                    returnTo,
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
                                    placeholder: "Quick search menus",
                                    search: searchValue
                                )
                            )
                        )
                    },
                    toolbar: {
                        if permissions.allows(
                            Menu.Permissions.create
                        ) {
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
