import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebComponents
import WebBuilders

struct UserRoleTable: Leaf {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let roles: [Components.Schemas.UserRoleListItemSchema]
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
                H1("User roles")

                if state.isAdded { P("User role added successfully.") }
                if state.isEdited { P("User role edited successfully.") }
                if state.isRemoved { P("User role removed successfully.") }
                if state.canAdd {
                    Div {
                        if state.canAdd {
                            AdminNavigationButton(
                                "Add role",
                                href: "/admin/user/roles/add/"
                            ).html()
                        }
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/user/roles/",
                        placeholder: "Quick search user roles",
                        search: state.search
                    )
                ).html()

                if state.roles.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/user/roles/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href("/admin/user/roles/?page=\(totalPages)")
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No user roles yet."
                                : "No user roles match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "user:roles:delete"
                    )
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/user/roles/remove/",
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
                                        Th("Name")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for role in state.roles {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(id: role.id)
                                                ).html()
                                            }
                                            Td(role.name ?? "")
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
                                                                "/admin/user/roles/\(role.id)/",
                                                            className: nil,
                                                            permission:
                                                                "user:roles:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/user/roles/\(role.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "user:roles:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/user/roles/\(role.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "user:roles:delete"
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
                            path: "/admin/user/roles/",
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
