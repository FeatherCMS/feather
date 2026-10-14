import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthMagicLinkConfirmation: Component {
    struct State {
        let item: AdminRemoveItemContext
        let credentialId: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove user magic link",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.item.label],
                action: "/admin/auth/magic-links/\(state.item.id)/remove/",
                nonceToken: state.nonceToken
            )
        )
    }
}
