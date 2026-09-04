import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableTable: Leaf {

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

    func renderHTML() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).renderHTML()
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
                        ).renderHTML()
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
                ).renderHTML()

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
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/system/variables/remove/",
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
                                            ListTableSelectAllCheckbox().renderHTML()
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
                                                ).renderHTML()
                                            }
                                            Td(variable.name ?? "")
                                                .data(
                                                    "label",
                                                    "Name"
                                                )
                                                .columnWidth(percent: 50)
                                            Td(variable.value)
                                                .data(
                                                    "label",
                                                    "Value"
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
                                            ).renderHTML()
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ).renderHTML()
                    ).renderHTML()
                    ListTablePagination(
                        state: .init(
                            path: "/admin/system/variables/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ).renderHTML()
                }
            }
        }
        .class("cms-section")
    }
}
