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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add user invitation")
            AccountInvitationForm(
                state: state.form,
                action: "/admin/account/invitations/add/",
                submitLabel: "Add invitation"
            ).html()
        }
        .class("cms-section")
    }
}
