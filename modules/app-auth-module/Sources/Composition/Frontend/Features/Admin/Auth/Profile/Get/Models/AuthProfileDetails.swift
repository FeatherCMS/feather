import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AuthProfileDetails: Component {

    struct State {
        let profile: AdminGetAuthProfileModel
        let canEdit: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Profile")

            AdminDetailsField(label: "ID", value: state.profile.id)
            AdminDetailsField(label: "Email", value: state.profile.email)
            AdminDetailsField(
                label: "First name",
                value: state.profile.firstName ?? ""
            )
            AdminDetailsField(
                label: "Last name",
                value: state.profile.lastName ?? ""
            )
            AdminDetailsField(
                label: "Image URL",
                value: state.profile.imageURL ?? ""
            )

            Div {
                P("Roles")
                    .class("admin-details-field__label")
                if state.profile.roles.isEmpty {
                    P("No roles assigned")
                        .class("admin-details-field__value")
                }
                else {
                    Ul {
                        for role in state.profile.roles {
                            Li(role)
                        }
                    }
                }
            }
            .class("admin-details-field")

            Details {
                Summary("Permissions")
                if state.profile.permissions.isEmpty {
                    P("No permissions assigned")
                }
                else {
                    Ul {
                        for permission in state.profile.permissions {
                            Li(permission)
                        }
                    }
                }
            }
            .class("admin-details-field")

            if state.canEdit {
                Div {
                    AdminNavigationButton(
                        "Edit profile",
                        href: "/admin/auth/profile/edit/"
                    )
                }
                .class("button-row", "admin-detail-actions")
            }
        }
        .class("cms-section")
    }
}
