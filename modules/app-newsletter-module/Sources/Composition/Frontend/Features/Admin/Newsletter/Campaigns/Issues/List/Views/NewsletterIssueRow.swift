import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueRow: Component {
    let newsletterId: String
    let item: AdminNewsletterIssueItem
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            Td(item.subject).data("label", "Subject")
            Td(item.status).data("label", "Status")
            Td(item.scheduledAt).data("label", "Scheduled")
            Td(item.createdAt).data("label", "Created")
            context.build(
                NewAdminListRowActions(
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
                        .init(
                            "Remove",
                            href:
                                NewsletterAdminRoutes.issueRemove(
                                    newsletterID: RouterPath(newsletterId),
                                    issueID: RouterPath(item.id)
                                )
                                .description,
                            style: .destructive,
                            permission: Permissions.Issues.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
