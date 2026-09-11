import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserIdentityConfirmation: Component {

    struct State {
        let id: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            AdminConfirmationDialog(
                state: .init(
                    breadcrumb: state.breadcrumb,
                    title: "Remove identity",
                    message:
                        "Are you sure you want to remove this identity? This action cannot be undone.",
                    details: [],
                    submitLabel: "Remove identity",
                    actionURL: "/admin/user/identities/\(state.id)/remove/",
                    cancelURL: "/admin/user/identities/"
                )
            )
        )
    }
}
