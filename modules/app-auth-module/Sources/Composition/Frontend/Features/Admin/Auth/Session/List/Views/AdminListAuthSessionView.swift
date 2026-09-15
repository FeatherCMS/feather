import AuthContracts
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminListAuthSessionView: Component {
    struct State {
        let identityID: String
        let items: [AdminListAuthSessionModel.Item]
        let canRemove: Bool
    }

    let state: State

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(
                    links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "User", link: "/admin/user/"),
                        .init(
                            label: "Identity",
                            link: "/admin/user/identities/\(state.identityID)/"
                        ),
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Sessions",
                        description: "Manage active sessions for this identity."
                    )
                )
            )
            context.render(
                NewAdminTabBar(links: [
                    .init(
                        label: "Sessions",
                        href:
                            "/admin/user/identities/\(state.identityID)/sessions/",
                        isCurrent: true
                    ),
                    .init(
                        label: "Magic links",
                        href:
                            "/admin/auth/magic-links/?userId=\(state.identityID)",
                        isCurrent: false
                    ),
                ])
            )
            if state.items.isEmpty {
                context.render(
                    NewAdminListEmptyState(
                        message: "No active sessions.",
                        icon: FeatherIcons.inbox()
                    )
                )
            }
            else {
                context.render(
                    NewAdminListShell(
                        layout: .init(
                            name: "auth-sessions",
                            columns: [
                                .fraction(2), .fraction(2), .fraction(1),
                                .fixed(180),
                            ]
                        ),
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Authentication")
                                    Th("Expires")
                                    Th("Persistent")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in state.items {
                                    Tr {
                                        Td(item.authenticationType)
                                        Td("\(item.expiresAt)")
                                        Td(item.isPersistent ? "Yes" : "No")
                                        Td {
                                            if state.canRemove {
                                                context.render(
                                                    NewAdminRowButton(
                                                        "Remove",
                                                        href:
                                                            "/admin/user/identities/\(state.identityID)/sessions/\(item.id)/remove/",
                                                        style: .destructive
                                                    )
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                    )
                )
            }
        }
        .class("cms-section")
    }
}
