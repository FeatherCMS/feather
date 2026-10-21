import FeatherWebAdmin
import Hummingbird
import SGML
import WebComponents
import RedirectModule

struct RedirectRuleConfirmation: Component {
    let id: String
    let source: String
    let nonceToken: String
    let returnTo: String?
    let routes: RedirectModule.Rule.Router.Routes

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove redirect rule",
                    description: "This action cannot be undone."
                ),
                selectedItems: [source],
                action: routes.removePath(id),
                hiddenFields: [
                    .init(name: "ids", value: id),
                    .init(name: "_nonce", value: nonceToken),
                ]
                    + (returnTo.map { [.init(name: "returnTo", value: $0)] }
                        ?? [])
            )
        )
    }
