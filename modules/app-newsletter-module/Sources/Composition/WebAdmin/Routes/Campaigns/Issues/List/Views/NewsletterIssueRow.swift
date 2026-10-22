import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueRow: Component {
    let newsletterId: String
    let item: AdminNewsletterIssueItem
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            Td(item.subject).data("label", "Subject")
            Td(item.status).data("label", "Status")
            Td(item.scheduledAt).data("label", "Scheduled")
            Td(item.createdAt).data("label", "Created")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href:
                                NewsletterAdminRoutes.issueDetails(
                                    newsletterID: RouterPath(newsletterId),
                                    issueID: RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.primary),
                            permission: Permissions.Issues.read
                        ),
                        .init(
                            "Edit",
                            href:
                                NewsletterAdminRoutes.issueEdit(
                                    newsletterID: RouterPath(newsletterId),
                                    issueID: RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.secondary),
                            permission: Permissions.Issues.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
