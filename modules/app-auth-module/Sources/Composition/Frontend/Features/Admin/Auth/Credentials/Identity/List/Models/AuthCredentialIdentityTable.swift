import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AuthCredentialIdentityTable: Leaf {
    struct State {
        let canAccess: Bool
        let permissions: Set<String>
        let identities:
            [UserAdminAPI.Components.Schemas.UserIdentityListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your identity cannot access user credentials.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).renderHTML()
                H1("Credentials")
                P("Select a user to manage their credentials.")
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/credentials/",
                        placeholder: "Quick search users",
                        search: state.search
                    )
                ).renderHTML()
                if state.identities.isEmpty {
                    P(
                        state.search.isEmpty
                            ? "No user identities yet."
                            : "No users match your search."
                    )
                }
                else {
                    ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Identity")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for identity in state.identities {
                                    Tr {
                                        Td(identity.id)
                                            .data("label", "Identity")
                                        Td {
                                            A("Credentials")
                                                .href(
                                                    "/admin/auth/credentials/\(identity.id)/"
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                    ).renderHTML()
                    ListTablePagination(
                        state: .init(
                            path: "/admin/auth/credentials/",
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
