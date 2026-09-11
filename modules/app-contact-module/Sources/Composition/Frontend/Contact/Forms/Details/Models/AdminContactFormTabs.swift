import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminContactFormTabs: Component {
    enum Tab { case details, emails, submissions }

    let formId: String
    let active: Tab

    func html(context: inout RenderContext) -> Div {
        context.render(AdminPillTabs(links: [
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
        ]))
    }
}
