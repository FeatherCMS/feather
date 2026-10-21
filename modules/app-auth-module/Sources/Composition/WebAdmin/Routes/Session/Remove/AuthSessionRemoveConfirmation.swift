import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthSessionRemoveConfirmation: Component {
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
                    title: "Remove session",
                    description: "The session will be signed out immediately."
                ),
                selectedItems: [
                    state.item.label,
                    state.item.id,
                ],
                action:
                    "/admin/user/identities/\(state.identityId)/sessions/\(state.item.id)/remove/",
                nonceToken: state.nonceToken
            )
        )
    }
}
