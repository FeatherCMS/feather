import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMenuItemTable: Component {

    struct State {
        let menuId: String
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let items: [Components.Schemas.WebMenuItemListItemSchema]
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
                H1("Items")

                if state.isAdded {
                    P("Item added successfully.")
                }
                if state.isEdited {
                    P("Item edited successfully.")
                }
                if state.isRemoved {
                    P("Item removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add item",
                            href: "/admin/web/menus/\(state.menuId)/items/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/web/menus/\(state.menuId)/items/",
                        placeholder: "Quick search items",
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
                                .href(
                                    "/admin/web/menus/\(state.menuId)/items/?page=1"
                                )
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/web/menus/\(state.menuId)/items/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No items yet."
                                : "No items match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "web:menu-items:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action:
                                "/admin/web/menus/\(state.menuId)/items/bulk-remove/",
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
                                        Th("Label")
                                        Th("URL")
                                        Th("Priority")
                                        Th("Blank")
                                        Th("Permission")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for item in state.items {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: item.id
                                                    )
                                                )
                                            }
                                            Td(item.label)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Label"
                                                )
                                            Td(item.url)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "URL"
                                                )
                                            Td("\(item.priority)")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Priority"
                                                )
                                            Td(item.isBlank ? "Yes" : "No")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Blank"
                                                )
                                            Td(item.permission)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Permission"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/",
                                                            className: nil,
                                                            permission:
                                                                "web:menu-items:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "web:menu-items:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "web:menu-items:delete"
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
                            path: "/admin/web/menus/\(state.menuId)/items/",
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
