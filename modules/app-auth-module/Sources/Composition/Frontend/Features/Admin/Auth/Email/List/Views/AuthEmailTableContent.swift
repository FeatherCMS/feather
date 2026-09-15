import AuthAdminAPI
import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthEmailTableContent: Component {
    let state: AuthEmailTable.State

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
                                        "Your identity cannot access user emails."
                                ),
                                icon: FeatherIcons.alertCircle()
                            )
                        )
                    }
                    else if state.links.isEmpty {
                        context.build(
                            NewAdminListEmptyState(
                                message: state.search.isEmpty
                                    ? "No user emails yet."
                                    : "No user emails match your search.",
                                icon: FeatherIcons.inbox()
                            )
                        )
                    }
                    else {
                        context.build(
                            NewAdminListShell(
                                layout: .init(
                                    name: "auth-emails",
                                    columns: [
                                        .fraction(2),
                                        .fraction(2),
                                        .fixed(220),
                                    ]
                                ),
                                table: Table {
                                    Thead {
                                        Tr {
                                            Th("Identity")
                                            Th("Email")
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for email in state.links {
                                            Tr {
                                                Td(
                                                    state.identityNames[
                                                        email.identityId
                                                    ] ?? email.identityId
                                                )
                                                .data("label", "Identity")
                                                Td(email.email)
                                                    .data("label", "Email")
                                                context.build(
                                                    NewAdminListRowActions(
                                                        label: "Actions",
                                                        actions: [
                                                            .init(
                                                                "View",
                                                                href:
                                                                    "/admin/auth/emails/\(email.id)/",
                                                                style: .ghost(
                                                                    .primary
                                                                ),
                                                                permission:
                                                                    AuthPermissions
                                                                    .Emails.read
                                                            ),
                                                            .init(
                                                                "Edit",
                                                                href:
                                                                    "/admin/auth/emails/\(email.id)/edit/",
                                                                style: .ghost(
                                                                    .secondary
                                                                ),
                                                                permission:
                                                                    AuthPermissions
                                                                    .Emails
                                                                    .update
                                                            ),
                                                            .init(
                                                                "Remove",
                                                                href:
                                                                    "/admin/auth/emails/\(email.id)/remove/",
                                                                style:
                                                                    .destructive,
                                                                permission:
                                                                    AuthPermissions
                                                                    .Emails
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
                    context.build(
                        NewAdminListSearch(
                            state: .init(
                                action: "/admin/auth/emails/",
                                placeholder: "Quick search user emails",
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
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add new",
                                        href: "/admin/auth/emails/add/"
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
                                path: "/admin/auth/emails/",
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
