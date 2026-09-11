import Hummingbird
import FeatherAdmin
import FeatherContracts
import HTML
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

private struct SystemVariableRow: Component {

    struct State: Sendable {
        let id: String
        let name: String
        let value: String
        let actions: [NewAdminListRowActions.Action]

        init(
            variable: Components.Schemas.SystemVariableListItemSchema
        ) {
            self.id = variable.id
            self.name = variable.name ?? ""
            self.value = variable.value
            self.actions = [
                .init(
                    "Details",
                    href: SystemVariableRoutes.details(RouterPath(variable.id)).description,
                    style: .ghost(.primary),
                    permission: SystemPermissions.Variables.read
                ),
                .init(
                    "Edit",
                    href: SystemVariableRoutes.edit(RouterPath(variable.id)).description,
                    style: .ghost(.secondary),
                    permission: SystemPermissions.Variables.update
                ),
                .init(
                    "Remove",
                    href: SystemVariableRoutes.remove(variable.id),
                    style: .destructive,
                    permission: SystemPermissions.Variables.delete
                )
            ]
        }
    }

    let state: State
    let permissions: ListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(SystemPermissions.Variables.delete) {
                context.render(NewAdminListRowCheckbox(id: state.id))
            }
            Td(state.name)
                .data("label", "Name")
                .columnWidth(percent: 50)
            Td(state.value)
                .data("label", "Value")
                .columnWidth(percent: 50)
            context.render(NewAdminListRowActions(
                label: "Actions",
                actions: state.actions,
                permissions: permissions
            ))
        }
    }
}

private struct SystemVariableTableContent: Component {

    let variables: [Components.Schemas.SystemVariableListItemSchema]
    let permissions: ListActions
    let pageState: ListPageState
    let search: String

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(SystemPermissions.Variables.delete)

        return context.render(NewAdminList(
            table: {
                if pageState.isPageOutOfRange {
                    context.render(NewAdminListInvalidPageState(
                        pageState: pageState,
                        path: SystemVariableRoutes.list.description,
                        search: search
                    ))
                }
                else if variables.isEmpty {
                    context.render(NewAdminListEmptyState(
                        message: search.isEmpty
                            ? "No system variables yet."
                            : "No system variables match your search.",
                        icon: FeatherIcons.inbox(),
                        action: {
                            if search.isEmpty && permissions.allows(SystemPermissions.Variables.create) {
                                context.render(NewAdminButton(
                                    "Add variable",
                                    href: SystemVariableRoutes.add.description
                                ))
                            }
                        }
                    ))
                }
                else {
                    context.render(NewAdminListSelectionForm(
                        state: .init(
                            action: SystemVariableRoutes.removeRoute.description,
                            pageState: pageState,
                            search: search,
                            button: .init("Remove selected", style: .destructive),
                            isEnabled: canDelete
                        ),
                        table: context.render(NewAdminListShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canDelete {
                                            context.render(NewAdminListSelectAllCheckbox())
                                        }
                                        Th("Name").columnWidth(percent: 50)
                                        Th("Value").columnWidth(percent: 50)
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for variable in variables {
                                        context.render(SystemVariableRow(
                                            state: .init(
                                                variable: variable
                                            ),
                                            permissions: permissions
                                        ))
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canDelete) { $0.class("select-table") }
                        ))
                    ))
                }
            },
            search: {
                context.render(NewAdminListSearch(
                    state: .init(
                        action: SystemVariableRoutes.list.description,
                        placeholder: "Quick search system variables",
                        search: search
                    )
                ))
            },
            toolbar: {
                if permissions.allows(SystemPermissions.Variables.create) {
                    context.render(NewAdminListToolbar {
                        context.render(NewAdminButton(
                            "Add variable",
                            href: SystemVariableRoutes.add.description
                        ))
                    })
                }
            },
            pagination: {
                context.render(NewAdminListPagination(
                    state: .init(
                        path: SystemVariableRoutes.list.description,
                        pageState: pageState,
                        search: search
                    )
                ))
            }
        ))
    }
}

struct SystemVariableTable: Component {

    struct State {
        let permissions: Set<PermissionKey>
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: ListPageState
        let search: String
        let breadcrumb: NewAdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let permissions = ListActions(state.permissions)

        return Section {
            context.render(NewAdminBreadcrumb(state: state.breadcrumb))
            if !permissions.allows(SystemPermissions.Variables.list) {
                context.render(NewAdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot access system variables."
                    ),
                    icon: FeatherIcons.alertCircle()
                ))
            }
            else {
                H1("System variables")


                context.render(SystemVariableTableContent(
                    variables: state.variables,
                    permissions: permissions,
                    pageState: state.pageState,
                    search: state.search
                ))
            }
        }
        .class("cms-section")
    }
}
