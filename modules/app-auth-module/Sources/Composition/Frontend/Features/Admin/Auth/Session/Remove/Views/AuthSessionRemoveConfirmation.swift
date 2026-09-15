import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthSessionRemoveConfirmation: Component {
    struct State {
        let item: NewAdminRemoveItemContext
        let identityId: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove session",
                    description: "The session will be signed out immediately."
                ),
                selectedItems: [
                    state.item.label,
                    state.item.id,
                ],
                action:
                    "/admin/user/identities/\(state.identityId)/sessions/\(state.item.id)/remove/",
                cancel: "/admin/user/identities/\(state.identityId)/",
                nonceToken: state.nonceToken
            )
        )
    }
}
