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
import WebComponents
import WebBuilders

struct AuthProfileDetails: Leaf {

    struct State {
        let profile: AdminGetAuthProfileModel
        let canEdit: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor().renderHTML()
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Profile")

            AdminDetailsField(label: "ID", value: state.profile.id).renderHTML()
            Div {
                P("Profile image")
                    .class("admin-details-field__label")
                if state.profile.profileImageAssetId != nil {
                    Img(
                        src: "/admin/auth/profile/image/",
                        alt: "My profile picture"
                    )
                    .width(120)
                    .height(120)
                    .style(
                        "display:block;width:120px;height:120px;object-fit:cover;border-radius:18px;border:1px solid var(--cms-gray-3);"
                    )
                }
                else {
                    P("No profile image assigned")
                        .class("admin-details-field__value")
                }
            }
            .class("admin-details-field")
            AdminDetailsField(
                label: "First name",
                value: state.profile.firstName ?? ""
            ).renderHTML()
            AdminDetailsField(
                label: "Last name",
                value: state.profile.lastName ?? ""
            ).renderHTML()
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
                    ).renderHTML()
                }
                .class("button-row", "admin-detail-actions")
            }
        }
        .class("cms-section")
    }
}
