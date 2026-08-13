import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebStandards

struct WebMenuDetails: Component {
    struct State {
        let menu: WebMenuDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Menu details")
            AdminDetailsField(label: "ID", value: state.menu.id)
            AdminDetailsField(label: "Key", value: state.menu.key)
            AdminDetailsField(label: "Name", value: state.menu.name)
            AdminDetailsField(label: "Notes", value: state.menu.notes ?? "")

            Div {
                AdminNavigationButton(
                    "Edit menu",
                    href: "/admin/web/menus/\(state.menu.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove menu",
                    href: "/admin/web/menus/\(state.menu.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class(
                "button-row",
                "web-menu-details-actions",
                "admin-detail-actions"
            )

            H2("Item")
            if state.isAdded {
                P("Item added successfully.")
            }
            if state.isRemoved {
                P("Item removed successfully.")
            }
            if state.permissions.contains(
                AdminWeb.Scope.menuItems.permission(for: .create)
            ) {
                Div {
                    AdminNavigationButton(
                        "Add item",
                        href: "/admin/web/menus/\(state.menu.id)/items/add/"
                    )
                }
                .class("button-row", "web-menu-details-item-add")
            }
            if state.menu.items.isEmpty {
                P("No menu items found for this menu.")
            }
            else {
                let canRemove = state.permissions.contains(
                    "web:menu-items:delete"
                )
                ListTableBulkRemoveForm(
                    state: .init(
                        action:
                            "/admin/web/menus/\(state.menu.id)/items/bulk-remove/",
                        page: 1,
                        search: "",
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
                                for item in state.menu.items {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: item.id)
                                            )
                                        }
                                        Td(item.label)
                                        Td(item.url)
                                        Td("\(item.priority)")
                                        Td(item.isBlank ? "Yes" : "No")
                                        Td(item.permission)
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/web/menus/\(state.menu.id)/items/\(item.id)/",
                                                        className: nil,
                                                        permission:
                                                            "web:menu-items:read"
                                                    ),
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/web/menus/\(state.menu.id)/items/\(item.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "web:menu-items:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/web/menus/\(state.menu.id)/items/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "web:menu-items:delete"
                                                    ),
                                                ],
                                                permissions: state.permissions
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
            }
        }
        .class("cms-section")
    }
}
