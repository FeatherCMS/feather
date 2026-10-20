import FeatherWebAdmin
import SGML
import WebComponents

struct AccountInvitationConfirmation: Component {

    struct State {
        let id: String
        let email: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove user invitation",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.email],
                action: "/admin/account/invitations/\(state.id)/remove/",
                submit: .init(label: "Remove invitation", style: .destructive),
                nonceToken: state.nonceToken
            )
        )
    }
}
