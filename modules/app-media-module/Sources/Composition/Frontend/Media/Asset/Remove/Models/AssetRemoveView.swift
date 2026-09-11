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
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            AdminConfirmationDialog(
                state: .init(
                    breadcrumb: breadcrumb,
                    title: "Remove media asset",
                    message:
                        "Are you sure you want to remove this asset? This action cannot be undone.",
                    details: [
                        .init(prefix: "ID: ", value: id)
                    ],
                    submitLabel: "Remove asset",
                    actionURL: "/admin/media/assets/\(id)/remove/",
                    cancelURL: "/admin/media/assets/"
                )
            )
        )
    }
}
