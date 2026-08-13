import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AccountInvitationAdd: Component {

    struct State {
        let form: AccountInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add user invitation")
            AccountInvitationForm(
                state: state.form,
                action: "/admin/account/invitations/add/",
                submitLabel: "Add invitation"
            )
        }
        .class("cms-section")
    }
}
