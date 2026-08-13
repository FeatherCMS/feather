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
