import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserInvitationEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: UserInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit user invitation")
            if state.isEdited { P("User invitation edited successfully.") }
            UserInvitationForm(
                state: state.form,
                action: "/admin/user/invitations/\(state.id)/edit/",
                submitLabel: "Edit invitation",
                removeHref: "/admin/user/invitations/\(state.id)/remove/",
                removeLabel: "Remove invitation"
            )
        }
        .class("cms-section")
    }
}
