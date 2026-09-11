import FeatherAdmin
import FeatherContracts
import HTML
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

private enum SystemVariableRoutes {
    static let list = "/admin/system/variables/"
    static let remove = "/admin/system/variables/remove/"

    static func details(_ id: String) -> String { "\(list)\(id)/" }
    static func edit(_ id: String) -> String { "\(list)\(id)/edit/" }
    static func remove(_ id: String) -> String { "\(list)\(id)/remove/" }
}

private struct SystemVariablePermissions {
    let actions: ListActions

    init(_ permissions: Set<PermissionKey>) {
        actions = ListActions(permissions)
    }

    var canList: Bool { actions.allows(SystemPermissions.Variables.list) }
    var canCreate: Bool { actions.allows(SystemPermissions.Variables.create) }
    var canDelete: Bool { actions.allows(SystemPermissions.Variables.delete) }
}

private struct SystemVariableRow: Component {
    let variable: Components.Schemas.SystemVariableListItemSchema
    let permissions: ListActions
    let canDelete: Bool

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if canDelete {
                context.render(NewAdminListRowCheckbox(id: variable.id))
            }
            Td(variable.name ?? "")
                .data("label", "Name")
                .columnWidth(percent: 50)
            Td(variable.value)
                .data("label", "Value")
                .columnWidth(percent: 50)
            context.render(NewAdminListRowActions(
                label: "Actions",
                actions: [
                    .init(
                        "Details",
                        href: SystemVariableRoutes.details(variable.id),
                        style: .ghost(.primary),
                        permission: SystemPermissions.Variables.read
                    ),
                    .init(
                        "Edit",
                        href: SystemVariableRoutes.edit(variable.id),
                        style: .ghost(.secondary),
                        permission: SystemPermissions.Variables.update
                    ),
                    .init(
                        "Remove",
                        href: SystemVariableRoutes.remove(variable.id),
                        style: .destructive,
                        permission: SystemPermissions.Variables.delete
                    )
                ],
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
                context.render(NewAdminListSelectionForm(
                    state: .init(
                        action: SystemVariableRoutes.remove,
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
                                        variable: variable,
                                        permissions: permissions,
                                        canDelete: canDelete
                                    ))
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canDelete) { $0.class("select-table") }
                    ))
                ))
            },
            toolbar: {
                if permissions.allows(SystemPermissions.Variables.create) {
                    context.render(NewAdminListToolbar {
                        context.render(NewAdminButton(
                            "Add variable",
                            href: "\(SystemVariableRoutes.list)add/"
                        ))
                    })
                }
            },
            pagination: {
                context.render(NewAdminListPagination(
                    state: .init(
                        path: SystemVariableRoutes.list,
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
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let permissions: Set<PermissionKey>
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: ListPageState
        let search: String
        let breadcrumb: NewAdminBreadcrumb
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let permissions = SystemVariablePermissions(state.permissions)

        return Section {
            if !permissions.canList {
                context.render(NewAdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot access system variables."
                    ),
                    icon: FeatherIcons.alertCircle()
                ))
            }
            else {
                context.render(state.breadcrumb)
                H1("System variables")

                if state.isAdded { P("System variable added successfully.") }
                if state.isEdited { P("System variable edited successfully.") }
                if state.isRemoved { P("System variable removed successfully.") }

                context.render(NewAdminListSearch(
                    state: .init(
                        action: SystemVariableRoutes.list,
                        placeholder: "Quick search system variables",
                        search: state.search
                    )
                ))

                if state.variables.isEmpty {
                    if state.pageState.isPageOutOfRange {
                        context.render(NewAdminListInvalidPageState(
                            pageState: state.pageState,
                            path: SystemVariableRoutes.list
                        ))
                    }
                    else {
                        context.render(NewAdminListEmptyState(
                            message: state.search.isEmpty
                                ? "No system variables yet."
                                : "No system variables match your search."
                        ))
                    }
                }
                else {
                    context.render(SystemVariableTableContent(
                        variables: state.variables,
                        permissions: permissions.actions,
                        pageState: state.pageState,
                        search: state.search
                    ))
                }
            }
        }
        .class("cms-section")
    }
}
