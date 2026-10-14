import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthCredentialConfirmation: Component {
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
                    title: "Remove user credential",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.item.label],
                action: "/admin/auth/credentials/\(state.item.id)/remove/",
                nonceToken: state.nonceToken
            )
        )
    }
}
