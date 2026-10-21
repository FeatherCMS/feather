import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthEmailConfirmation: Component {
    struct State {
        let item: AdminRemoveItemContext
        let identityId: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove user email",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.item.label],
                action: "/admin/auth/emails/\(state.item.id)/remove/",
                nonceToken: state.nonceToken
            )
        )
    }
}
