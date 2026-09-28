import FeatherAdmin
import Hummingbird
import SGML
import WebComponents

struct RedirectRuleConfirmation: Component {
    let id: String
    let source: String
    let nonceToken: String
    let returnTo: String?

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove redirect rule",
                    description: "This action cannot be undone."
                ),
                selectedItems: [source],
                action: RedirectRuleRoutes.remove(RouterPath(id)).description,
                hiddenFields: [
                    .init(name: "ids", value: id),
                    .init(name: "_nonce", value: nonceToken),
                ]
                    + (returnTo.map { [.init(name: "returnTo", value: $0)] }
                        ?? [])
            )
        )
    }
}
