import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationAdd: Component {

    struct State {
        let form: AccountInvitationForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user invitation",
                        description:
                            "Invite a user and assign their initial roles."
                    )
                )
            )
            context.build(
                AccountInvitationForm(
                    state: state.form,
                    action: "/admin/account/invitations/add/",
                    submitLabel: "Add invitation"
                )
            )
        }
        .class("cms-section")
    }
}
