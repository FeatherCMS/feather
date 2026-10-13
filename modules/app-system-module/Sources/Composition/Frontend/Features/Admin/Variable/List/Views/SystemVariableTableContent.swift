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

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(SystemPermissions.Variables.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemVariableRoutes.list.description
                            )
                        )
                    }
                    else if variables.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message:
                                        "No system variables match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
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
                            context.build(
                                NewAdminListEmptyState(
                                    message: "No system variables yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            SystemPermissions.Variables.create
                                        ) {
                                            context.build(
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
                        context.build(
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
                                table: context.build(
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
                                                        context.build(
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
                                                    context.build(
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
                    context.build(
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
                        context.build(
                            NewAdminListToolbar {
                                context.build(
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
                    context.build(
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
