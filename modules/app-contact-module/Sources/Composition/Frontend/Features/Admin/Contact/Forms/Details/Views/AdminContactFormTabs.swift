import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminContactFormTabs: Component {
    enum Tab { case details, fields, emails, submissions }

    let formId: String
    let active: Tab

    func html(context: inout BuilderContext) -> Div {
        context.build(
            NewAdminTabBar(links: [
                .init(
                    label: "Details",
                    href: "/admin/contact/forms/\(formId)/details/",
                    isCurrent: active == .details
                ),
                .init(
                    label: "Fields",
                    href: "/admin/contact/forms/\(formId)/fields/",
                    isCurrent: active == .fields
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
        )
    }
}
