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

struct AuthCredentialIdentityTable: Component {
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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your identity cannot access user credentials.")
            }
            else {
                context.render(AdminBreadcrumb(state: state.breadcrumb))
                H1("Credentials")
                P("Select a user to manage their credentials.")
                context.render(ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/credentials/",
                        placeholder: "Quick search users",
                        search: state.search
                    )
                ))
                if state.identities.isEmpty {
                    P(
                        state.search.isEmpty
                            ? "No user identities yet."
                            : "No users match your search."
                    )
                }
                else {
                    context.render(ListTableShell(
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
                    ))
                    context.render(ListTablePagination(
                        state: .init(
                            path: "/admin/auth/credentials/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ))
                }
            }
        }
        .class("cms-section")
    }
}
