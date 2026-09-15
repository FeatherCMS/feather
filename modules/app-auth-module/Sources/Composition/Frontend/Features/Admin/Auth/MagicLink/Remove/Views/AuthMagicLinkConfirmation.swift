import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthMagicLinkConfirmation: Component {
    struct State {
        let item: NewAdminRemoveItemContext
        let credentialId: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove user magic link",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.item.label],
                action: "/admin/auth/magic-links/\(state.item.id)/remove/",
                cancel: "/admin/auth/magic-links/",
                nonceToken: state.nonceToken
            )
        )
    }
}
