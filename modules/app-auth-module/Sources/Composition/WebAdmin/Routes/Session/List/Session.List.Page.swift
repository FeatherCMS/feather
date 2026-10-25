import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Session.List {
    struct Page: Component {
        struct State {
            let identityID: String
            let items: [Model.Item]
            let canRemove: Bool
            let routes: Session.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: [
                            .init(
                                label: "Admin",
                                link: state.routes.admin.path
                            ),
                            .init(label: "Auth", link: state.routes.auth.path),
                            .init(
                                label: "Identity",
                                link:
                                    state.routes.identityPath(state.identityID)
                            ),
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Sessions",
                            description:
                                "Manage active sessions for this identity."
                        )
                    )
                )
                context.build(
                    AdminTabBar(links: [
                        .init(
                            label: "Sessions",
                            href: state.routes.listPath(
                                identityID: state.identityID
                            ),
                            isCurrent: true
                        ),
                        .init(
                            label: "Magic links",
                            href: state.routes.magicLinksPath(
                                identityID: state.identityID
                            ),
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
                                    .actions,
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
}
