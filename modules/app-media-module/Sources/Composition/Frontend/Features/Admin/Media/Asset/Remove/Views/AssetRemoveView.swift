import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetRemoveView: Component {
    let item: NewAdminRemoveItemContext
    let nonceToken: String

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove media item",
                    description: "Confirm removal of this media item."
                ),
                selectedItems: [item.label],
                action: MediaAssetRoutes.remove(RouterPath(item.id))
                    .description,
                submit: .init(label: "Remove item", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
