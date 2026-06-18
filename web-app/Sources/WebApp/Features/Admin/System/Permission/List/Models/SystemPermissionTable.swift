import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemPermissionTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let items: [Components.Schemas.SystemPermissionListItemSchema]
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
                H1("System permissions")

                if state.isAdded {
                    P("System permission added successfully.")
                }
                if state.isEdited {
                    P("System permission edited successfully.")
                }
                if state.isRemoved {
                    P("System permission removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add permission",
                            href: "/admin/system/permissions/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/system/permissions/",
                        placeholder: "Quick search system permissions",
                        search: state.search
                    )
                )

                if state.items.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1")
                                .href("/admin/system/permissions/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/system/permissions/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No system permissions yet."
                                : "No system permissions match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "system:permissions:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/system/permissions/bulk-remove/",
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
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for permission in state.items {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: permission.id
                                                    )
                                                )
                                            }
                                            Td(permission.name)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Name"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/system/permissions/\(permission.id)/",
                                                            className: nil,
                                                            permission:
                                                                "system:permissions:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/system/permissions/\(permission.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "system:permissions:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/system/permissions/\(permission.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "system:permissions:delete"
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
                            path: "/admin/system/permissions/",
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
