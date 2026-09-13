import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthEmailConfirmation: Component {
    struct State {
        let id: String
        let identityId: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove user email",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.identityId],
                action: "/admin/auth/emails/\(state.id)/remove/",
                cancel: "/admin/auth/emails/",
                nonceToken: state.nonceToken
            )
        )
    }
}
