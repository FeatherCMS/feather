import HTML
import SGML
import WebStandards

struct ContactFieldRemoveView: Component {
    let fieldId: String
    let label: String
    let breadcrumb: AdminBreadcrumb.State
    func content() -> some BasicTag {
        let basePath = "/admin/contact/fields"
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
