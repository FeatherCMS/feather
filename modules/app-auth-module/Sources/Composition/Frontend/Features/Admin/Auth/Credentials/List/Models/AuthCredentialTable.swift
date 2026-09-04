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

struct AuthCredentialTable: Leaf {
    struct State {
        let canAccess: Bool
        let permissions: Set<String>
        let credentials:
            [AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema]
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
                H1("User credentials")
                if state.permissions.contains("auth:credential:create") {
                    Div {
                        AdminNavigationButton(
                            "Add credential",
                            href: "/admin/auth/credentials/add/"
                        ).renderHTML()
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/credentials/",
                        placeholder: "Quick search credentials",
                        search: state.search
                    )
                ).renderHTML()
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
                                    Th("User")
                                    Th("Email")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for credential in state.credentials {
                                    Tr {
                                        Td(credential.identityName)
                                            .data("label", "User")
                                        Td(credential.email)
                                            .data("label", "Email")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/auth/credentials/\(credential.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "auth:credential:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/auth/credentials/\(credential.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "auth:credential:delete"
                                                    ),
                                                ],
                                                permissions: state.permissions
                                            )
                                        ).renderHTML()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table", "credential-table")
                    ).renderHTML()
                    ListTablePagination(
                        state: .init(
                            path:
                                "/admin/auth/credentials/",
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
