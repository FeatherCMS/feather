import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AccountInvitationForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit user invitation")
            if state.isEdited { P("User invitation edited successfully.") }
            context.render(
                AccountInvitationForm(
                    state: state.form,
                    action: "/admin/account/invitations/\(state.id)/edit/",
                    submitLabel: "Edit invitation",
                    removeHref:
                        "/admin/account/invitations/\(state.id)/remove/",
                    removeLabel: "Remove invitation"
                )
            )
        }
        .class("cms-section")
    }
}
