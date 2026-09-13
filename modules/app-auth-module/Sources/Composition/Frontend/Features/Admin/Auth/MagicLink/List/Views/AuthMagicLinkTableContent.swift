import AuthAdminAPI
import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthMagicLinkTableContent: Component {
    let state: AuthMagicLinkTable.State

    func html(context: inout RenderContext) -> Div {
        let actions = NewAdminListActions(
            Set(state.permissions.map(PermissionKey.init))
        )
        let pageState = NewAdminListPageState(
            page: state.page,
            pageSize: state.pageSize,
            total: state.total
        )

        return context.render(
            NewAdminList(
                table: {
                    if !state.canAccess {
                        context.render(
                            NewAdminStatusView(
                                state: .init(
                                    title: state.deniedInfo,
                                    message: state.deniedMessage
                                ),
                                icon: FeatherIcons.alertCircle()
                            )
                        )
                    }
                    else if state.links.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: state.search.isEmpty
                                    ? "No user magic links yet."
                                    : "No magic links match your search.",
                                icon: FeatherIcons.inbox()
                            )
                        )
                    }
                    else {
                        context.render(
                            NewAdminListShell(
                                layout: .init(
                                    name: "auth-magic-links",
                                    columns: [
                                        .fraction(2),
                                        .fraction(2),
                                        .fraction(1),
                                        .fraction(1),
                                        .fixed(220),
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
                                                            link.credentialId
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
                                                Td(link.isUsed ? "Yes" : "No")
                                                    .data("label", "Used")
                                                context.render(
                                                    NewAdminListRowActions(
                                                        label: "Actions",
                                                        actions: [
                                                            .init(
                                                                "View",
                                                                href:
                                                                    "/admin/auth/magic-links/\(link.id)/",
                                                                style: .ghost(
                                                                    .primary
                                                                ),
                                                                permission:
                                                                    AuthPermissions
                                                                    .MagicLinks
                                                                    .read
                                                            ),
                                                            .init(
                                                                "Edit",
                                                                href:
                                                                    "/admin/auth/magic-links/\(link.id)/edit/",
                                                                style: .ghost(
                                                                    .secondary
                                                                ),
                                                                permission:
                                                                    AuthPermissions
                                                                    .MagicLinks
                                                                    .update
                                                            ),
                                                            .init(
                                                                "Remove",
                                                                href:
                                                                    "/admin/auth/magic-links/\(link.id)/remove/",
                                                                style:
                                                                    .destructive,
                                                                permission:
                                                                    AuthPermissions
                                                                    .MagicLinks
                                                                    .delete
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
                    context.render(
                        NewAdminListSearch(
                            state: .init(
                                action: "/admin/auth/magic-links/",
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
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: "/admin/auth/magic-links/add/"
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.render(
                        NewAdminListPagination(
                            state: .init(
                                path: "/admin/auth/magic-links/",
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
