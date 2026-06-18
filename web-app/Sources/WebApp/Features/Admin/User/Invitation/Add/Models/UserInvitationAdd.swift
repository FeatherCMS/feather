import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserInvitationAdd: Component {

    struct State {
        let form: UserInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add user invitation")
            UserInvitationForm(
                state: state.form,
                action: "/admin/user/invitations/add/",
                submitLabel: "Add invitation"
            )
        }
        .class("cms-section")
    }
}
