import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

struct SystemVariableTableContent: Component {
    let variables: [Components.Schemas.SystemVariableListItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?
    let routes: Variable.Router.Routes

    private var searchValue: String {
        search ?? ""
    }

    private var returnTo: String {
        AdminLocation.url(
            path: routes.list.path,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(
            SystemModule.Variable.Permissions.delete
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
                    else if variables.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No system variables match your search.",
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
                                    message: "No system variables yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            SystemModule.Variable.Permissions
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
                                    action: AdminLocation.remove(
                                        path: routes.remove.path,
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
                                            name: "system-variables",
                                            columns: [
                                                .fraction(1),
                                                .fraction(2),
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
                                                    Th("Value")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for variable in variables {
                                                    context.build(
                                                        SystemVariableRow(
                                                            state: .init(
                                                                variable:
                                                                    variable,
                                                                returnTo:
                                                                    returnTo,
                                                                routes:
                                                                    routes
                                                            ),
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
                                action: routes.list.path,
                                placeholder: "Quick search system variables",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(
                        SystemModule.Variable.Permissions.create
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
