import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import SGML
import UserModule
import WebComponents

extension Role.Remove {
    struct Confirmation: Component {
        let routes: Role.Router.Routes
        let id: String
        let name: String
        let nonceToken: String?

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove user role",
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
