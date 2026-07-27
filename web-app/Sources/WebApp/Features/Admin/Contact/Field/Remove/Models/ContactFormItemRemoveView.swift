import HTML
import SGML
import WebStandards

struct ContactFormItemRemoveView: Component {
    let formId: String
    let itemId: String
    let label: String
    let breadcrumb: AdminBreadcrumb.State
    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove contact form field",
                message:
                    "Are you sure you want to remove this field? This action cannot be undone.",
                details: [.init(prefix: "Label: ", value: label)],
                submitLabel: "Remove field",
                actionURL:
                    "/admin/contact/forms/\(formId)/items/\(itemId)/remove/",
                cancelURL: "/admin/contact/forms/\(formId)/items/"
            )
        )
    }
}
