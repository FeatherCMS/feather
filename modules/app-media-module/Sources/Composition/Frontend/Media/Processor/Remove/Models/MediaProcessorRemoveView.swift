import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaProcessorRemoveView: Leaf {
    let id: String
    let cancelURL: String
    let formURL: String
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove processor",
                message:
                    "Are you sure you want to remove this processor? This action cannot be undone.",
                details: [
                    .init(prefix: "ID: ", value: id)
                ],
                submitLabel: "Remove processor",
                actionURL: formURL,
                cancelURL: cancelURL
            )
        ).html()
    }
}
