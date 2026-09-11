import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemVariableTable: Branch {

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

    var children: [any Component] {
        state.breadcrumb
        NewAdminList(
            table: {
                Div {}
            }
        )
        NewAdminListSearch(
            state: .init(
                action: "/admin/system/variables/",
                placeholder: "Quick search system variables",
                search: state.search
            )
        )
        NewAdminListToolbar {
            Div {}
        }
        NewAdminListShell(table: Table {})
        NewAdminListRowActions(
            label: "Actions",
            actions: [],
            permissions: []
        )
        NewAdminListSelectAllCheckbox()
        NewAdminListRowCheckbox(id: "")
        NewAdminListPagination(
            state: .init(
                path: "/admin/system/variables/",
                page: state.page,
                pageSize: state.pageSize,
                total: state.total,
                search: state.search
            )
        )
    }

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                state.breadcrumb.html()
                H1("System variables")

                if state.isAdded { P("System variable added successfully.") }
                if state.isEdited { P("System variable edited successfully.") }
                if state.isRemoved { P("System variable removed successfully.") }

                NewAdminListSearch(
                    state: .init(
                        action: "/admin/system/variables/",
                        placeholder: "Quick search system variables",
                        search: state.search
                    )
                ).html()

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
                    let canRemove = state.permissions.contains("system:variables:delete")
                    NewAdminList(
                    table: {
                        ListTableRemoveForm(
                            state: .init(
                                action: "/admin/system/variables/remove/",
                                page: state.page,
                                search: state.search,
                                canRemove: canRemove,
                                buttonTitle: "Remove selected"
                            ),
                            table: NewAdminListShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            if canRemove { NewAdminListSelectAllCheckbox().html() }
                                            Th("Name").columnWidth(percent: 50)
                                            Th("Value").columnWidth(percent: 50)
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for variable in state.variables {
                                            Tr {
                                                if canRemove {
                                                    NewAdminListRowCheckbox(id: variable.id).html()
                                                }
                                                Td(variable.name ?? "")
                                                    .data("label", "Name")
                                                    .columnWidth(percent: 50)
                                                Td(variable.value)
                                                    .data("label", "Value")
                                                    .columnWidth(percent: 50)
                                                NewAdminListRowActions(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            "Details",
                                                            href: "/admin/system/variables/\(variable.id)/",
                                                            style: .ghost(.primary),
                                                            permission: "system:variables:read"
                                                        ),
                                                        .init(
                                                            "Edit",
                                                            href: "/admin/system/variables/\(variable.id)/edit/",
                                                            style: .ghost(.primary),
                                                            permission: "system:variables:update"
                                                        ),
                                                        .init(
                                                            "Remove",
                                                            href: "/admin/system/variables/\(variable.id)/remove/",
                                                            style: .destructive,
                                                            permission: "system:variables:delete"
                                                        )
                                                    ],
                                                    permissions: state.permissions
                                                ).html()
                                            }
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                                .if(canRemove) { $0.class("select-table") }
                            ).html()
                        ).html()
                    },
                    toolbar: {
                        if state.canAdd {
                            NewAdminListToolbar {
                                NewAdminButton(
                                    "Add variable",
                                    href: "/admin/system/variables/add/"
                                ).html()
                            }.html()
                        }
                    },
                    pagination: {
                        NewAdminListPagination(
                            state: .init(
                                path: "/admin/system/variables/",
                                page: state.page,
                                pageSize: state.pageSize,
                                total: state.total,
                                search: state.search
                            )
                        ).html()
                    }
                    ).html()
                }
            }
        }
        .class("cms-section")
    }
}
