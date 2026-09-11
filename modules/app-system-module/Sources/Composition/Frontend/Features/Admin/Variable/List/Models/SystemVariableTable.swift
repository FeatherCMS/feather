import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
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
    let canRead: Bool
    let canUpdate: Bool
    let canDelete: Bool
    let canCreate: Bool

    init(_ permissions: Set<String>) {
        canRead = permissions.contains("system:variables:read")
        canUpdate = permissions.contains("system:variables:update")
        canDelete = permissions.contains("system:variables:delete")
        canCreate = permissions.contains("system:variables:create")
    }
}

private struct SystemVariableRow: Component {
    let variable: Components.Schemas.SystemVariableListItemSchema
    let permissions: Set<String>
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
                        permission: "system:variables:read"
                    ),
                    .init(
                        "Edit",
                        href: SystemVariableRoutes.edit(variable.id),
                        style: .ghost(.secondary),
                        permission: "system:variables:update"
                    ),
                    .init(
                        "Remove",
                        href: SystemVariableRoutes.remove(variable.id),
                        style: .destructive,
                        permission: "system:variables:delete"
                    )
                ],
                permissions: permissions
            ))
        }
    }
}

struct SystemVariableTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: NewAdminBreadcrumb
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
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
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/system/variables/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href("/admin/system/variables/?page=\(totalPages)")
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No system variables yet."
                                : "No system variables match your search."
                        )
                    }
                }
                else {
                    let permissions = SystemVariablePermissions(state.permissions)
                    context.render(NewAdminList(
                    table: {
                        context.render(NewAdminListSelectionForm(
                            state: .init(
                                action: SystemVariableRoutes.remove,
                                page: state.page,
                                search: state.search,
                                button: .init(
                                    "Remove selected",
                                    style: .destructive
                                ),
                                isEnabled: permissions.canDelete
                            ),
                            table: context.render(NewAdminListShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            if permissions.canDelete {
                                                context.render(NewAdminListSelectAllCheckbox())
                                            }
                                            Th("Name").columnWidth(percent: 50)
                                            Th("Value").columnWidth(percent: 50)
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for variable in state.variables {
                                            context.render(SystemVariableRow(
                                                variable: variable,
                                                permissions: state.permissions,
                                                canDelete: permissions.canDelete
                                            ))
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                                .if(permissions.canDelete) { $0.class("select-table") }
                            ))
                        ))
                    },
                    toolbar: {
                        if permissions.canCreate {
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
                                page: state.page,
                                pageSize: state.pageSize,
                                total: state.total,
                                search: state.search
                            )
                        ))
                    }
                    ))
                }
            }
        }
        .class("cms-section")
    }
}
