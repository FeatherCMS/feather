import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueDetailsView: Component {
    let newsletterId: String
    let issueId: String
    let model: AdminAddNewsletterIssueModel
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if permissions.allows(Permissions.Issues.update) {
            actions.append(
                .init(
                    label: "Edit",
                    href:
                        NewsletterAdminRoutes.issueEdit(
                            newsletterID: RouterPath(newsletterId),
                            issueID: RouterPath(issueId)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if permissions.allows(Permissions.Issues.delete) {
            actions.append(
                .init(
                    label: "Remove",
                    href:
                        NewsletterAdminRoutes.issueRemove(
                            newsletterID: RouterPath(newsletterId),
                            issueID: RouterPath(issueId)
                        )
                        .description,
                    style: .destructive
                )
            )
        }
        return Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Issues",
                            link:
                                NewsletterAdminRoutes.campaignIssues(
                                    RouterPath(newsletterId)
                                )
                                .description
                        )
                    ]
                )
            )
            context.build(
                NewsletterCampaignHeader(
                    campaignId: newsletterId,
                    active: .issues
                )
            )
            H2("Issue details")
            Div {
                context.build(
                    NewAdminDetailField(label: "Subject", value: model.subject)
                )
                context.build(
                    NewAdminDetailField(label: "Content", value: model.content)
                )
                context.build(
                    NewAdminDetailField(
                        label: "Scheduled",
                        value: formattedScheduledAt
                    )
                )
            }
            .class("admin-detail-view-fields")
            .style("display:grid;gap:12px;")
            if !actions.isEmpty {
                Div {
                    for action in actions {
                        context.build(
                            NewAdminButton(
                                action.label,
                                href: action.href,
                                style: action.style
                            )
                        )
                    }
                }
                .class("new-admin-detail-actions")
                .style("display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;")
            }
        }
        .class("cms-section")
    }

    private var formattedScheduledAt: String {
        guard !model.scheduledAt.isEmpty else { return "Not scheduled" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        guard let date = formatter.date(from: model.scheduledAt) else {
            return model.scheduledAt
        }
        return date.formatted(date: .long, time: .shortened)
    }
}
