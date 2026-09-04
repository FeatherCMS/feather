import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuTable: Leaf {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let rules: [Components.Schemas.WebMenuListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).html()
                H1("Menus")

                if state.isAdded {
                    P("Menu added successfully.")
                }
                if state.isEdited {
                    P("Menu edited successfully.")
                }
                if state.isRemoved {
                    P("Menu removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add menu",
                            href: "/admin/web/menus/add/"
                        ).html()
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/web/menus/",
                        placeholder: "Quick search menus",
                        search: state.search
                    )
                ).html()

                if state.rules.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/web/menus/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/web/menus/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No menus yet."
                                : "No menus match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "web:menus:delete"
                    )
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/web/menus/remove/",
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
                                            ListTableSelectAllCheckbox().html()
                                        }
                                        Th("Key")
                                        Th("Name")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for rule in state.rules {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: rule.id
                                                    )
                                                ).html()
                                            }
                                            Td(rule.key)
                                                .data(
                                                    "label",
                                                    "Key"
                                                )
                                            Td(rule.name)
                                                .data(
                                                    "label",
                                                    "Name"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/web/menus/\(rule.id)/",
                                                            className: nil,
                                                            permission:
                                                                "web:menus:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/web/menus/\(rule.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "web:menus:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/web/menus/\(rule.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "web:menus:delete"
                                                        ),
                                                    ],
                                                    permissions: state
                                                        .permissions
                                                )
                                            ).html()
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ).html()
                    ).html()
                    ListTablePagination(
                        state: .init(
                            path: "/admin/web/menus/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ).html()
                }
            }
        }
        .class("cms-section")
    }
}
