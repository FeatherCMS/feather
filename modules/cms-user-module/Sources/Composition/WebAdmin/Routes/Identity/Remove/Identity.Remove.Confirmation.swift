import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import UserModule
import WebBuilders
import WebComponents

extension Identity.Remove {
    struct Confirmation: Component {
        let routes: Identity.Router.Routes
        let id: String
        let name: String
        let nonceToken: String?

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove user identity",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [name.emptyToNil ?? id],
                    action: routes.removePath(id),
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
}
