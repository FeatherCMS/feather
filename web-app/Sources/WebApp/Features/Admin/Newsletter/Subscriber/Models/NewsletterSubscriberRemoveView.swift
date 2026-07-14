import HTML
import SGML
import WebStandards

struct NewsletterSubscriberRemoveView: Component {
    let email: String
    let subscriberId: String
    let newsletterId: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove subscriber",
                message: "Are you sure you want to remove this subscriber? This action cannot be undone.",
                details: [.init(prefix: "Email: ", value: email)],
                submitLabel: "Remove subscriber",
                actionURL: "/admin/newsletters/\(newsletterId)/subscribers/\(subscriberId)/remove/",
                cancelURL: "/admin/newsletters/\(newsletterId)/subscribers/"
            )
        )
    }
}
