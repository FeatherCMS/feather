import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
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
