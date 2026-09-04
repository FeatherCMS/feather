import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct SubmissionMailRemove: Leaf {
    let formId: String
    let mail: AdminContactFormEmail
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove contact form email",
                message:
                    "Are you sure you want to remove this email definition? This action cannot be undone.",
                details: [.init(prefix: "Subject: ", value: mail.subject)],
                submitLabel: "Remove email",
                actionURL:
                    "/admin/contact/forms/\(formId)/emails/remove/",
                cancelURL: "/admin/contact/forms/\(formId)/emails/",
                hiddenFields: [.init(name: "selectedIds[]", value: mail.id)]
            )
        ).html()
    }
}
