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
    let item: NewAdminRemoveItemContext
    let nonceToken: String
    let cancelURL: String
    let formURL: String

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: MediaProcessorRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove processor",
                    description: "Confirm removal of this media processor."
                ),
                selectedItems: [item.label],
                action: formURL,
                cancel: cancelURL,
                submitLabel: "Remove processor",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
