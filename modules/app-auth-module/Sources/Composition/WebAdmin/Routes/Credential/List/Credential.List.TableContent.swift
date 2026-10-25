import AuthAdminAPI
import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Credential.List {
    struct TableContent: WebComponents.Component {
        let state: Component.State

        func html(context: inout BuilderContext) -> Div {
            let actions = AdminListActions(
                Set(state.permissions.map(PermissionKey.init))
            )
            let pageState = AdminListPageState(
                page: state.page,
                pageSize: state.pageSize,
                total: state.total
            )

            return context.build(
                AdminList(
                    table: {
                        if !state.canAccess {
                            context.build(
                                AdminStatusView(
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
                                AdminListEmptyState(
                                    message: state.search.isEmpty
                                        ? "No credentials yet."
                                        : "No credentials match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if actions.allows(
                                            Credential.Permissions.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: state.routes.add.path
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                        else {
                            context.build(
                                AdminListShell(
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
                                            for credential in state.credentials
                                            {
                                                context.build(
                                                    Row(
                                                        credential: credential,
                                                        actions: actions,
                                                        routes: state.routes
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
                            AdminListSearch(
                                state: .init(
                                    action: state.routes.list.path,
                                    placeholder: "Quick search credentials",
                                    search: state.search
                                )
                            )
                        )
                    },
                    toolbar: {
                        if actions.allows(Credential.Permissions.create) {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
                                            href: state.routes.add.path
                                        )
                                    )
                                }
                            )
                        }
                    },
                    pagination: {
                        context.build(
                            AdminListPagination(
                                state: .init(
                                    path: state.routes.list.path,
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
}
