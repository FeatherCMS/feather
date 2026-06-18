import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

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
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("System variables")

                if state.isAdded {
                    P("System variable added successfully.")
                }
                if state.isEdited {
                    P("System variable edited successfully.")
                }
                if state.isRemoved {
                    P("System variable removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add variable",
                            href: "/admin/system/variables/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/system/variables/",
                        placeholder: "Quick search system variables",
                        search: state.search
                    )
                )

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
                                .href(
                                    "/admin/system/variables/?page=\(totalPages)"
                                )
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
                    let canRemove = state.permissions.contains(
                        "system:variables:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/system/variables/bulk-remove/",
                            page: state.page,
                            search: state.search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: ListTableShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canRemove {
                                            ListTableSelectAllCheckbox()
                                        }
                                        Th("Name")
                                            .columnWidth(percent: 50)
                                        Th("Value")
                                            .columnWidth(percent: 50)
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for variable in state.variables {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: variable.id
                                                    )
                                                )
                                            }
                                            Td(variable.name)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Name"
                                                )
                                                .columnWidth(percent: 50)
                                            Td(variable.value)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Value"
                                                )
                                                .columnWidth(percent: 50)
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/system/variables/\(variable.id)/",
                                                            className: nil,
                                                            permission:
                                                                "system:variables:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/system/variables/\(variable.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "system:variables:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/system/variables/\(variable.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "system:variables:delete"
                                                        ),
                                                    ],
                                                    permissions: state
                                                        .permissions
                                                )
                                            )
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("bulk-select-table") }
                        )
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/system/variables/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }
}
