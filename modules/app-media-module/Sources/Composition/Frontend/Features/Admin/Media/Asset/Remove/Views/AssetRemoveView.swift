import FeatherAdmin
import FeatherValidation
import Foundation
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
                breadcrumb: MediaAssetRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove media item",
                    description: "Confirm removal of this media item."
                ),
                selectedItems: [item.label],
                action: MediaAssetRoutes.remove(RouterPath(item.id)).description,
                cancel: MediaAssetRoutes.list.description,
                submitLabel: "Remove item",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
