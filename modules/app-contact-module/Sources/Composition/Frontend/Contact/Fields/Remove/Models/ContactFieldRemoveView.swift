import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFieldRemoveView: Leaf {
    let fieldId: String
    let label: String
    let breadcrumb: AdminBreadcrumb.State
    func html() -> some BasicTag {
        let basePath = "/admin/contact/fields"
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove contact form field",
                message:
                    "Are you sure you want to remove this field? This action cannot be undone.",
                details: [.init(prefix: "Label: ", value: label)],
                submitLabel: "Remove field",
                actionURL: "\(basePath)/\(fieldId)/remove/",
                cancelURL: "\(basePath)/"
            )
        ).html()
    }
}
