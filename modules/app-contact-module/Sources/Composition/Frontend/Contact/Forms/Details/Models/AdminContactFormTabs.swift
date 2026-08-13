import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminContactFormTabs: Component, FlowContent {
    enum Tab { case details, emails, submissions }

    let formId: String
    let active: Tab

    func content() -> some BasicTag {
        AdminPillTabs(links: [
            .init(
                label: "Details",
                href: "/admin/contact/forms/\(formId)/details/",
                isCurrent: active == .details
            ),
            .init(
                label: "Emails",
                href: "/admin/contact/forms/\(formId)/emails/",
                isCurrent: active == .emails
            ),
            .init(
                label: "Submissions",
                href: "/admin/contact/forms/\(formId)/submissions/",
                isCurrent: active == .submissions
            ),
        ])
        .content()
    }
}
