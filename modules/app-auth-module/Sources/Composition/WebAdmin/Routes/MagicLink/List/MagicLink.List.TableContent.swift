import AuthAdminAPI
import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension MagicLink.List {
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
                                        title: state.deniedInfo,
                                        message: state.deniedMessage
                                    ),
                                    icon: FeatherIcons.alertCircle()
                                )
                            )
                        }
                        else if state.links.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: state.search.isEmpty
                                        ? "No user magic links yet."
                                        : "No magic links match your search.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                        else {
                            context.build(
                                AdminListShell(
                                    layout: .init(
                                        name: "auth-magic-links",
                                        columns: [
                                            .fraction(2),
                                            .fraction(2),
                                            .fraction(1),
                                            .fraction(1),
                                            .actions,
                                        ]
                                    ),
                                    table: Table {
                                        Thead {
                                            Tr {
                                                Th("Email")
                                                Th("Expires")
                                                Th("Persistent")
                                                Th("Used")
                                                Th("Actions")
                                            }
                                        }
                                        Tbody {
                                            for link in state.links {
                                                Tr {
                                                    Td(
                                                        state.emailByAuthEmailId[
                                                            String(
                                                                link
                                                                    .credentialId
                                                            )
                                                        ] ?? "—"
                                                    )
                                                    .data("label", "Email")
                                                    Td(
                                                        DateFormatting
                                                            .formatUnixTimestamp(
                                                                link.expiresAt
                                                            )
                                                    )
                                                    .data("label", "Expires")
                                                    Td(
                                                        link.isPersistent
                                                            ? "Yes" : "No"
                                                    )
                                                    .data("label", "Persistent")
                                                    Td(
                                                        link.isUsed
                                                            ? "Yes" : "No"
                                                    )
                                                    .data("label", "Used")
                                                    context.build(
                                                        AdminListRowActions(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    "View",
                                                                    href: state
                                                                        .routes
                                                                        .detailsPath(
                                                                            link
                                                                                .id
                                                                        ),
                                                                    style:
                                                                        .ghost(
                                                                            .primary
                                                                        ),
                                                                    permission:
                                                                        MagicLink
                                                                        .Permissions
                                                                        .read
                                                                ),
                                                                .init(
                                                                    "Edit",
                                                                    href: state
                                                                        .routes
                                                                        .editPath(
                                                                            link
                                                                                .id
                                                                        ),
                                                                    style:
                                                                        .ghost(
                                                                            .secondary
                                                                        ),
                                                                    permission:
                                                                        MagicLink
                                                                        .Permissions
                                                                        .update
                                                                ),
                                                            ],
                                                            permissions: actions
                                                        )
                                                    )
                                                }
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
                                    placeholder: "Quick search magic links",
                                    search: state.search,
                                    queryItems: state.userID.map {
                                        [.init(name: "userId", value: $0)]
                                    } ?? []
                                )
                            )
                        )
                    },
                    toolbar: {
                        if state.canAdd {
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
                                    search: state.search,
                                    queryItems: state.userID.map {
                                        [.init(name: "userId", value: $0)]
                                    } ?? []
                                )
                            )
                        )
                    }
                )
            )
        }
    }
}
