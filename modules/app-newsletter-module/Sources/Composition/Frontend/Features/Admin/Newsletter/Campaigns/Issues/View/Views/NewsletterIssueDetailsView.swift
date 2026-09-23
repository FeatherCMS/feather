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
                    href: NewsletterAdminRoutes.issueEdit(
                        newsletterID: RouterPath(newsletterId),
                        issueID: RouterPath(issueId)
                    ).description,
                    style: .primary
                )
            )
        }
        if permissions.allows(Permissions.Issues.delete) {
            actions.append(
                .init(
                    label: "Remove",
                    href: NewsletterAdminRoutes.issueRemove(
                        newsletterID: RouterPath(newsletterId),
                        issueID: RouterPath(issueId)
                    ).description,
                    style: .destructive
                )
            )
        }
        return context.build(
            NewAdminDetailView(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Issues",
                        link: NewsletterAdminRoutes.campaignIssues(
                            RouterPath(newsletterId)
                        ).description
                    )
                ],
                pageHeader: .init(
                    title: "Campaign issue details",
                    description: "Review the issue content and delivery schedule."
                ),
                fields: [
                    .init(label: "Subject", value: model.subject),
                    .init(label: "Content", value: model.content),
                    .init(label: "Scheduled", value: formattedScheduledAt),
                ],
                actions: actions
            )
        )
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
