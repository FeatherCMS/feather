import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct UserIdentityConfirmation: Component {
    let id: String
    let name: String
    let nonceToken: String?

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: UserIdentityRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove user identity",
                    description: "This action cannot be undone."
                ),
                selectedItems: [name.emptyToNil ?? id],
                action: UserIdentityRoutes.remove(RouterPath(id)).description,
                cancel: UserIdentityRoutes.details(RouterPath(id)).description,
                hiddenFields: nonceToken.map {
                    [
                        .init(name: "ids", value: id),
                        .init(name: "_nonce", value: $0),
                    ]
                } ?? []
            )
        )
    }
}
