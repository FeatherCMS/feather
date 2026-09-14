import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationAdd: Component {

    struct State {
        let form: AccountInvitationForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user invitation",
                        description:
                            "Invite a user and assign their initial roles."
                    )
                )
            )
            context.render(
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
