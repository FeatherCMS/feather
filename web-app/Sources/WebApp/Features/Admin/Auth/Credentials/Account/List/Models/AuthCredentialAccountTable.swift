import AdminOpenAPI
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthCredentialAccountTable: Component {
    struct State {
        let canAccess: Bool
        let permissions: Set<String>
        let accounts: [Components.Schemas.UserAccountListItemSchema]
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
                H1("Credentials")
                P("Select a user to manage their credentials.")
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/credentials/",
                        placeholder: "Quick search users",
                        search: state.search
                    )
                )
                if state.accounts.isEmpty {
                    P(
                        state.search.isEmpty
                            ? "No user accounts yet."
                            : "No users match your search."
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
                                for account in state.accounts {
                                    Tr {
                                        Td(account.email)
                                            .data("label", "Email")
                                        Td {
                                            A("Credentials")
                                                .href(
                                                    "/admin/auth/credentials/\(account.id)/"
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/auth/credentials/",
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
