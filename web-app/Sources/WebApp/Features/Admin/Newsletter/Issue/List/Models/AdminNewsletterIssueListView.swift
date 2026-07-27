import HTML
import SGML
import WebStandards

struct AdminNewsletterIssueListView: Component {
    struct State {
        let newsletterId: String
        let items: [AdminNewsletterIssueListItem]
        let error: String?
        let permissions: Set<String>
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(
                campaignId: state.newsletterId,
                active: .issues
            )
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Campaign issues")
            if let error = state.error { P(error).class("error") }
            Div {
                AdminNavigationButton(
                    "Add issue",
                    href: "/admin/newsletters/\(state.newsletterId)/issues/add/"
                )
            }
            .class("button-row")
            Br()
            Br()
            if state.items.isEmpty {
                P("No issues yet.")
            }
            else {
                ListTableShell(
                    table: Table {
                        Thead {
                            Tr {
                                Th("Subject")
                                Th("Status")
                                Th("Scheduled")
                                Th("Created")
                                Th("Actions")
                            }
                        }
                        Tbody {
                            for item in state.items {
                                Tr {
                                    Td(item.subject).data("label", "Subject")
                                    Td(item.status).data("label", "Status")
                                    Td(item.scheduledAt)
                                        .data("label", "Scheduled")
                                    Td(item.createdAt).data("label", "Created")
                                    ListTableRowActions(
                                        state: .init(
                                            label: "Actions",
                                            actions: [
                                                .init(
                                                    title: "Edit",
                                                    href:
                                                        "/admin/newsletters/\(state.newsletterId)/issues/\(item.id)/edit/",
                                                    className: "edit",
                                                    permission:
                                                        "newsletter:issues:update"
                                                ),
                                                .init(
                                                    title: "Remove",
                                                    href:
                                                        "/admin/newsletters/\(state.newsletterId)/issues/\(item.id)/remove/",
                                                    className: "delete",
                                                    permission:
                                                        "newsletter:issues:delete"
                                                ),
                                            ],
                                            permissions: [
                                                "newsletter:issues:update",
                                                "newsletter:issues:delete",
                                            ]
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .class("cms-table", "action-table")
                )
                let deliveries = state.items.flatMap(\.deliveries)
                if !deliveries.isEmpty {
                    H2("Delivery status")
                    ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Issue")
                                    Th("Subscriber")
                                    Th("Status")
                                    Th("Sent")
                                    Th("Failure")
                                }
                            }
                            Tbody {
                                for delivery in deliveries {
                                    Tr {
                                        Td(delivery.issueSubject)
                                            .data("label", "Issue")
                                        Td(delivery.subscriberEmail)
                                            .data("label", "Subscriber")
                                        Td(delivery.status)
                                            .data("label", "Status")
                                        Td(delivery.sentAt)
                                            .data("label", "Sent")
                                        Td(delivery.failureReason)
                                            .data("label", "Failure")
                                    }
                                }
                            }
                        }
                        .class("cms-table")
                    )
                }
            }
        }
        .class("cms-section")
    }
}
