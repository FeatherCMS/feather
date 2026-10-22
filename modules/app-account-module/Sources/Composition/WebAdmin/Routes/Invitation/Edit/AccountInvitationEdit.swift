import AccountModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationEdit: Component {
    let routes: Invitation.Router.Routes

    struct State {
        let id: String
        let isEdited: Bool
        let form: AccountInvitationForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit user invitation",
                        description:
                            "Update the invited user and assigned roles."
                    )
                )
            )
            if state.isEdited { P("User invitation edited successfully.") }
            context.build(
                AccountInvitationForm(
                    state: state.form,
                    action: routes.invitationEdit(state.id) + "/",
                    submitLabel: "Edit invitation",
                    removeHref: routes.invitationRemove(state.id) + "/",
                    removeLabel: "Remove invitation"
                )
            )
        }
        .class("cms-section")
    }
}
