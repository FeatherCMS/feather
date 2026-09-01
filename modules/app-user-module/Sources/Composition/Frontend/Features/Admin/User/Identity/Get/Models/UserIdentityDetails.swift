import FeatherAdmin
import HTML
import SGML
import WebStandards

struct UserIdentityDetails: Component {
    struct State {
        let identity: AdminGetUserIdentityModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User identity details")
            AdminPillTabs(links: [
                .init(
                    label: "Details",
                    href: "/admin/user/identities/\(state.identity.id)/",
                    isCurrent: true
                ),
                .init(
                    label: "Profile",
                    href: "/admin/account/users/\(state.identity.id)/profile/",
                    isCurrent: false
                ),
                .init(
                    label: "Settings",
                    href: "/admin/account/users/\(state.identity.id)/settings/",
                    isCurrent: false
                ),
                .init(
                    label: "Sessions",
                    href:
                        "/admin/user/identities/\(state.identity.id)/sessions/",
                    isCurrent: false
                ),
                .init(
                    label: "Magic links",
                    href:
                        "/admin/auth/magic-links/?userId=\(state.identity.id)",
                    isCurrent: false
                ),
            ])

            AdminDetailsField(label: "Status", value: state.identity.status)
            if state.identity.roleNames.isEmpty {
                AdminDetailsField(label: "Roles", value: "No roles assigned")
            }
            else {
                Div {
                    P("Roles")
                        .class("admin-details-field__label")
                    Ul {
                        for roleName in state.identity.roleNames {
                            Li(roleName)
                        }
                    }
                }
                .class("admin-details-field")
            }

            Div {
                AdminNavigationButton(
                    "Edit identity",
                    href: "/admin/user/identities/\(state.identity.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove identity",
                    href: "/admin/user/identities/\(state.identity.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class(
                "button-row",
                "user-identity-details-actions",
                "admin-detail-actions"
            )

        }
        .class("cms-section")
    }

}
