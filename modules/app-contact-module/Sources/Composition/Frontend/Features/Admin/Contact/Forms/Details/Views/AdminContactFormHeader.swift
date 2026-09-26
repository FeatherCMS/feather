import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminContactFormHeader: Component {
    enum Tab: Sendable, Equatable {
        case details
        case emails
        case submissions
    }

    let formId: String
    let active: Tab

    func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form",
                        description:
                            "Manage this contact form, its emails, and submissions."
                    )
                )
            )
            context.build(
                NewAdminTabBar(links: [
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
            )
        }
    }
}
