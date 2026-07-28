import HTML
import SGML
import WebStandards

struct ContactFormFieldRemoveView: Component {
    let formId: String
    let fieldId: String
    let label: String
    let breadcrumb: AdminBreadcrumb.State
    func content() -> some BasicTag {
        let basePath =
            formId.isEmpty
            ? "/admin/contact/fields"
            : "/admin/contact/forms/\(formId)/items"
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
    }
}
