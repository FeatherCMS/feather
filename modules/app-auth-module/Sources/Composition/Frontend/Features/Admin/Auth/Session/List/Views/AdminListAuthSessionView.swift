import AuthContracts
import FeatherWebAdmin
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

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminBreadcrumb(
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
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Sessions",
                        description: "Manage active sessions for this identity."
                    )
                )
            )
            context.build(
                AdminTabBar(links: [
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
                context.build(
                    AdminListEmptyState(
                        message: "No active sessions.",
                        icon: FeatherIcons.inbox()
                    )
                )
            }
            else {
                context.build(
                    AdminListShell(
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
                                        Td("")
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
