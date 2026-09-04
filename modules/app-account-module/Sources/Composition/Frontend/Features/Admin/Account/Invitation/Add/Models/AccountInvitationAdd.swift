import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationAdd: Leaf {

    struct State {
        let form: AccountInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add user invitation")
            AccountInvitationForm(
                state: state.form,
                action: "/admin/account/invitations/add/",
                submitLabel: "Add invitation"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
