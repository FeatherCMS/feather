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

struct MediaProcessorRemoveView: Component {
    let id: String
    let cancelURL: String
    let formURL: String

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminRemoveConfirmation(
                breadcrumb: MediaProcessorRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove processor",
                    description: "Confirm removal of this media processor."
                ),
                selectedItems: [id],
                action: formURL,
                cancel: cancelURL,
                submitLabel: "Remove processor"
            )
        )
    }
}
