import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationAdd: Component {

    struct State {
        let form: AccountInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add user invitation")
            context.render(AccountInvitationForm(
                state: state.form,
                action: "/admin/account/invitations/add/",
                submitLabel: "Add invitation"
            ))
        }
        .class("cms-section")
    }
}
