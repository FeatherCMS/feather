import AdminOpenAPI
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthCredentialTable: Component {
    struct State {
        let accountID: String
        let canAccess: Bool
        let permissions: Set<String>
        let credentials: [Components.Schemas.UserCredentialListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot access user credentials.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("User credentials")
                Div {
                    AdminNavigationButton(
                        "Add credential",
                        href: "/admin/auth/credentials/\(state.accountID)/add/"
                    )
                }
                .class("button-row")
                Br()
                Br()
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/credentials/\(state.accountID)/",
                        placeholder: "Quick search credentials",
                        search: state.search
                    )
                )
                if state.credentials.isEmpty {
                    P(
                        state.search.isEmpty
                            ? "No credentials yet."
                            : "No credentials match your search."
                    )
                }
                else {
                    ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Email")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for credential in state.credentials {
                                    Tr {
                                        Td(credential.email)
                                            .data("label", "Email")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Edit",
                                                        href: "/admin/auth/credentials/\(credential.id)/edit/",
                                                        className: "edit",
                                                        permission: "auth:credential:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href: "/admin/auth/credentials/\(credential.id)/remove/",
                                                        className: "delete",
                                                        permission: "auth:credential:delete"
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
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/auth/credentials/\(state.accountID)/",
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
