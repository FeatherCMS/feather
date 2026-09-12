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
    let search: String?

    private var searchValue: String {
        search ?? ""
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(SystemPermissions.Variables.delete)

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
                        context.render(
                            NewAdminListEmptyState(
                                message: search?.isEmpty ?? true
                                    ? "No system variables yet."
                                    : "No system variables match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if !(search?.isEmpty ?? true) {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: SystemVariableRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                    else if search?.isEmpty ?? true,
                                        permissions.allows(
                                            SystemPermissions.Variables.create
                                        )
                                    {
                                        context.render(
                                            NewAdminButton(
                                                "Add new",
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
                                    action: SystemVariableRoutes.remove
                                        .description,
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
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("ID")
                                                        .columnWidth(
                                                            percent: 30
                                                        )
                                                    Th("Name")
                                                        .columnWidth(
                                                            percent: 35
                                                        )
                                                    Th("Value")
                                                        .columnWidth(
                                                            percent: 35
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
