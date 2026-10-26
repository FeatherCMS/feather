import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.Search {
    struct Row: Component {
        let newsletterId: String
        let item: Item
        let permissions: AdminListActions
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                Td(item.subject).data("label", "Subject")
                Td {
                    P(item.status)
                    if !item.deliveries.isEmpty {
                        let sentCount = item.deliveries
                            .filter {
                                $0.status == "sent"
                            }
                            .count
                        let failedDeliveries = item.deliveries.filter {
                            $0.status == "failed"
                        }
                        P("\(sentCount) sent, \(failedDeliveries.count) failed")
                            .class("admin-list-secondary")
                        if let failureReason = failedDeliveries.first?
                            .failureReason,
                            failureReason != "—"
                        {
                            P("Failure: \(failureReason)")
                                .class("admin-list-secondary")
                        }
                    }
                }
                .data("label", "Status")
                Td(item.scheduledAt).data("label", "Scheduled")
                Td(item.createdAt).data("label", "Created")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "View",
                                href: routes.issueDetailsPath(
                                    newsletterId: newsletterId,
                                    issueId: item.id
                                ),
                                style: .ghost(.primary),
                                permission: Issue.Permissions.read
                            ),
                            .init(
                                "Edit",
                                href: routes.issueEditPath(
                                    newsletterId: newsletterId,
                                    issueId: item.id
                                ),
                                style: .ghost(.secondary),
                                permission: Issue.Permissions.update
                            ),
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
