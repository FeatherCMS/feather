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
    let permissions: ListActions
    let pageState: ListPageState
    let search: String

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(SystemPermissions.Variables.delete)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemVariableRoutes.list.description,
                                search: search
                            )
                        )
                    }
                    else if variables.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: search.isEmpty
                                    ? "No system variables yet."
                                    : "No system variables match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if search.isEmpty
                                        && permissions.allows(
                                            SystemPermissions.Variables.create
                                        )
                                    {
                                        context.render(
                                            NewAdminButton(
                                                "Add variable",
                                                href: SystemVariableRoutes.add
                                                    .description
                                            )
                                        )
                                    }
                                }
                            )
                        )
                    }
                    else {
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: SystemVariableRoutes.removeRoute
                                        .description,
                                    pageState: pageState,
                                    search: search,
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.render(
                                    NewAdminListShell(
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("Name")
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    Th("Value")
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for variable in variables {
                                                    context.render(
                                                        SystemVariableRow(
                                                            state: .init(
                                                                variable:
                                                                    variable
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
                                search: search
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
                                        "Add variable",
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
                                search: search
                            )
                        )
                    )
                }
            )
        )
    }
}
