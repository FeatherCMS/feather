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
    let id: String

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: MediaAssetRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove media asset",
                    description: "Confirm removal of this media asset."
                ),
                selectedItems: [id],
                action: MediaAssetRoutes.remove(RouterPath(id)).description,
                cancel: MediaAssetRoutes.list.description,
                submitLabel: "Remove asset"
            )
        )
    }
}
