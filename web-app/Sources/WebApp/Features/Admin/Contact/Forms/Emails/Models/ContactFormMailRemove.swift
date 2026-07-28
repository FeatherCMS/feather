import HTML
import SGML
import WebStandards

struct ContactFormMailRemove: Component {
    let formId: String
    let mail: AdminContactFormEmail
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove contact form email",
                message:
                    "Are you sure you want to remove this email definition? This action cannot be undone.",
                details: [.init(prefix: "Subject: ", value: mail.subject)],
                submitLabel: "Remove email",
                actionURL:
                    "/admin/contact/forms/\(formId)/emails/\(mail.id)/remove/",
                cancelURL: "/admin/contact/forms/\(formId)/emails/"
            )
        )
    }
}
