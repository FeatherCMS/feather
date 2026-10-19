import SystemModule
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemVariableTableContent: Component {
    let variables: [Components.Schemas.SystemVariableListItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?

    private var searchValue: String {
        search ?? ""
    }

    private var returnTo: String {
        AdminLocation.url(
            path: SystemVariableRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(SystemModule.Variable.Permissions.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemVariableRoutes.list.description
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
                                AdminListEmptyState(
                                    message: "No system variables yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            SystemModule.Variable.Permissions.create
                                        ) {
                                            context.build(
                                                AdminButton(
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
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
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
                        AdminListSearch(
                            state: .init(
                                action: SystemVariableRoutes.list.description,
                                placeholder: "Quick search system variables",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(SystemModule.Variable.Permissions.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
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
                        AdminListPagination(
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
