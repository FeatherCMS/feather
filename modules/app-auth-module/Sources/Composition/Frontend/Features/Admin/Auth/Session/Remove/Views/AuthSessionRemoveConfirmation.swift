import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthSessionRemoveConfirmation: Component {
    struct State {
        let model: AdminRemoveAuthSessionModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove session",
                    description: "The session will be signed out immediately."
                ),
                selectedItems: [
                    state.model.identityEmail,
                    state.model.sessionId,
                ],
                action:
                    "/admin/user/identities/\(state.model.identityId)/sessions/\(state.model.sessionId)/remove/",
                cancel: "/admin/user/identities/\(state.model.identityId)/",
                nonceToken: state.nonceToken
            )
        )
    }
}
