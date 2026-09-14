import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldRemoveView: Component {
    let formId: String
    let fieldId: String
    let label: String
    let breadcrumb: AdminBreadcrumb.State
    func html(context: inout RenderContext) -> some BasicTag {
        let basePath = "/admin/contact/forms/\(formId)/fields"
        return context.render(
            AdminConfirmationDialog(
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
            )
        )
    }
}
