import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AccountInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit user invitation")
            if state.isEdited { P("User invitation edited successfully.") }
            AccountInvitationForm(
                state: state.form,
                action: "/admin/account/invitations/\(state.id)/edit/",
                submitLabel: "Edit invitation",
                removeHref: "/admin/account/invitations/\(state.id)/remove/",
                removeLabel: "Remove invitation"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
