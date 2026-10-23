import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension ContactForm {
    struct TabBar: Component {
        enum Tab { case details, fields, emails, submissions }

        let formId: String
        let active: Tab

        func html(context: inout BuilderContext) -> Div {
            context.build(
                AdminTabBar(links: [
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
}
