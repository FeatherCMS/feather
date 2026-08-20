import FeatherContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebStandards

struct UserIdentityTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let identities: [Components.Schemas.UserIdentityListItemSchema]
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
                H1("User identities")

                if state.isAdded {
                    P("User identity added successfully.")
                }
                if state.isEdited {
                    P("User identity edited successfully.")
                }
                if state.isRemoved {
                    P("User identity removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add identity",
                            href: "/admin/user/identities/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/user/identities/",
                        placeholder: "Quick search identities",
                        search: state.search
                    )
                )

                if state.identities.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/user/identities/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/user/identities/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No identities yet."
                                : "No identities match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "user:identities:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/user/identities/bulk-remove/",
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
                                        Th("Status")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for identity in state.identities {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: identity.id
                                                    )
                                                )
                                            }
                                            Td(identity.status.rawValue)
                                                .data("label", "Status")
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/user/identities/\(identity.id)/",
                                                            className: nil,
                                                            permission:
                                                                "user:identities:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/user/identities/\(identity.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "user:identities:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/user/identities/\(identity.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "user:identities:delete"
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
                            path: "/admin/user/identities/",
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
