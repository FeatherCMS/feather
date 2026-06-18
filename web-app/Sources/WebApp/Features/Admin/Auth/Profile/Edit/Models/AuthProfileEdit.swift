import HTML
import SGML
import WebStandards

struct AuthProfileEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        var form: AuthProfileForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit profile")
            if state.isEdited {
                P("Profile edited successfully.").class("success")
            }

            AuthProfileForm(
                state: state.form,
                action: "/admin/auth/profile/edit/",
                submitLabel: "Edit profile"
            )
        }
        .class("cms-section")
    }
}
