import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemVariableTableContent: Component {
    let variables: [Components.Schemas.SystemVariableListItemSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var searchValue: String {
        search ?? ""
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: SystemVariableRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(SystemPermissions.Variables.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemVariableRoutes.list.description
                            )
                        )
                    }
                    else if variables.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message:
                                        "No system variables match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: SystemVariableRoutes.list
                                                    .description,
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
                                    message: "No system variables yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            SystemPermissions.Variables.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: SystemVariableRoutes
                                                        .add
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
                                        path: SystemVariableRoutes.remove
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
                                table: context.render(
                                    NewAdminListShell(
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
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("Key")
                                                    Th("Value")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for variable in variables {
                                                    context.render(
                                                        SystemVariableRow(
                                                            state: .init(
                                                                variable:
                                                                    variable,
                                                                returnTo:
                                                                    returnTo
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
                    context.render(
                        NewAdminListSearch(
                            state: .init(
                                action: SystemVariableRoutes.list.description,
                                placeholder: "Quick search system variables",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(SystemPermissions.Variables.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: SystemVariableRoutes.add
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
                                path: SystemVariableRoutes.list.description,
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
