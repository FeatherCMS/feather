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
                    context.build(statusChip(item.status))
                }
                .data("label", "Status")
                Td {
                    let sentCount = item.deliveries
                        .filter {
                            $0.status == "sent"
                        }
                        .count
                    let failedCount = item.deliveries
                        .filter {
                            ["failed", "bounced"].contains($0.status)
                        }
                        .count
                    let totalCount = item.deliveries.count
                    Div {
                        context.build(
                            AdminChip(
                                label: "Total: \(totalCount)",
                                color: .gray
                            )
                        )
                        context.build(
                            AdminChip(
                                label: "Sent: \(sentCount)",
                                color: sentCount > 0 ? .green : .gray
                            )
                        )
                        context.build(
                            AdminChip(
                                label: "Failed: \(failedCount)",
                                color: failedCount > 0 ? .red : .gray
                            )
                        )
                    }
                    .style("display:flex;gap:6px;flex-wrap:wrap;")
                }
                .data("label", "Delivery")
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

        private func statusChip(_ status: String) -> AdminChip {
            switch status.lowercased() {
            case "draft": .init(label: "Draft", color: .gray)
            case "scheduled": .init(label: "Scheduled", color: .blue)
            case "sending": .init(label: "Sending", color: .yellow)
            case "sent": .init(label: "Sent", color: .green)
            case "failed": .init(label: "Failed", color: .red)
            default: .init(label: status, color: .gray)
            }
        }
    }
}
