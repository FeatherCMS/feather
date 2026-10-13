import AuthAdminAPI
import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthCredentialTableContent: Component {
    let state: AuthCredentialTable.State

    func html(context: inout BuilderContext) -> Div {
        let actions = NewAdminListActions(
            Set(state.permissions.map(PermissionKey.init))
        )
        let pageState = NewAdminListPageState(
            page: state.page,
            pageSize: state.pageSize,
            total: state.total
        )

        return context.build(
            NewAdminList(
                table: {
                    if !state.canAccess {
                        context.build(
                            NewAdminStatusView(
                                state: .init(
                                    title: "Forbidden",
                                    message:
                                        "Your identity cannot access user credentials."
                                ),
                                icon: FeatherIcons.alertCircle()
                            )
                        )
                    }
                    else if state.credentials.isEmpty {
                        context.build(
                            NewAdminListEmptyState(
                                message: state.search.isEmpty
                                    ? "No credentials yet."
                                    : "No credentials match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if actions.allows(
                                        AuthPermissions.Credential.create
                                    ) {
                                        context.build(
                                            NewAdminButton(
                                                "Add new",
                                                href:
                                                    "/admin/auth/credentials/add/"
                                            )
                                        )
                                    }
                                }
                            )
                        )
                    }
                    else {
                        context.build(
                            NewAdminListShell(
                                layout: .init(
                                    name: "auth-credentials",
                                    columns: [
                                        .fraction(2),
                                        .fraction(2),
                                        .fixed(220),
                                    ]
                                ),
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
                                            context.build(
                                                AuthCredentialRow(
                                                    credential: credential,
                                                    actions: actions
                                                )
                                            )
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                            )
                        )
                    }
                },
                search: {
                    context.build(
                        NewAdminListSearch(
                            state: .init(
                                action: "/admin/auth/credentials/",
                                placeholder: "Quick search credentials",
                                search: state.search
                            )
                        )
                    )
                },
                toolbar: {
                    if actions.allows(AuthPermissions.Credential.create) {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add new",
                                        href:
                                            "/admin/auth/credentials/add/"
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.build(
                        NewAdminListPagination(
                            state: .init(
                                path: "/admin/auth/credentials/",
                                pageState: pageState,
                                search: state.search
                            )
                        )
                    )
                }
            )
        )
    }
}
