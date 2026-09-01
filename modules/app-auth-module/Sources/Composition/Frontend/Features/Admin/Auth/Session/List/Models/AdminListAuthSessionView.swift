import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AdminListAuthSessionView: Component {
    struct State {
        let identityID: String
        let items: [AdminListAuthSessionModel.Item]
        let canRemove: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(
                state: .init(
                    links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "User", link: "/admin/user/"),
                        .init(
                            label: "Identity",
                            link: "/admin/user/identities/\(state.identityID)/"
                        ),
                        .init(
                            label: "Sessions",
                            link:
                                "/admin/user/identities/\(state.identityID)/sessions/"
                        ),
                    ]
                )
            )
            H1("Sessions")
            AdminPillTabs(links: [
                .init(
                    label: "Details",
                    href: "/admin/user/identities/\(state.identityID)/",
                    isCurrent: false
                ),
                .init(
                    label: "Profile",
                    href: "/admin/account/users/\(state.identityID)/profile/",
                    isCurrent: false
                ),
                .init(
                    label: "Settings",
                    href: "/admin/account/users/\(state.identityID)/settings/",
                    isCurrent: false
                ),
                .init(
                    label: "Sessions",
                    href:
                        "/admin/user/identities/\(state.identityID)/sessions/",
                    isCurrent: true
                ),
                .init(
                    label: "Magic links",
                    href: "/admin/auth/magic-links/?userId=\(state.identityID)",
                    isCurrent: false
                ),
            ])
            if state.items.isEmpty {
                P("No active sessions.")
            }
            else {
                Table {
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
                                        AdminNavigationButton(
                                            "Remove",
                                            href:
                                                "/admin/user/identities/\(state.identityID)/sessions/\(item.id)/remove/",
                                            classes: ["danger"]
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .class("cms-table", "action-table")
            }
        }
        .class("cms-section")
    }
}
