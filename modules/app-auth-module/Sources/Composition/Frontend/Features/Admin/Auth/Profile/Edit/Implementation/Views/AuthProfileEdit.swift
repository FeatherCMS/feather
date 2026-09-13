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
import WebBuilders
import WebComponents

struct AuthProfileEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        var form: AuthProfileForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))

            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit profile",
                        description: "Update the current administrator profile."
                    )
                )
            )
            if state.isEdited {
                P("Profile edited successfully.").class("success")
            }

            context.render(
                AuthProfileForm(
                    state: state.form,
                    action: "/admin/auth/profile/edit/",
                    submitLabel: "Edit profile"
                )
            )
        }
        .class("cms-section")
    }
}
