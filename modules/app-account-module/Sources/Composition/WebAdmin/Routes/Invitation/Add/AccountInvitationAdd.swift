import AccountModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationAdd: Component {
    let routes: Invitation.Router.Routes

    struct State {
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
                        title: "Add user invitation",
                        description:
                            "Invite a user and assign their initial roles."
                    )
                )
            )
            context.build(
                AccountInvitationForm(
                    state: state.form,
                    action: routes.invitationAdd.path + "/",
                    submitLabel: "Add invitation"
                )
            )
        }
        .class("cms-section")
    }
}
