import FeatherModuleKit
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.View {
    struct Details: Component {
        let newsletterId: String
        let issueId: String
        let model: Issue.Form.Model
        let permissions: AdminListActions
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> Section {
            var actions: [AdminDetailView.Action] = []
            if permissions.allows(Issue.Permissions.update) {
                actions.append(
                    .init(
                        label: "Edit",
                        href: routes.issueEditPath(
                            newsletterId: newsletterId,
                            issueId: issueId
                        ),
                        style: .primary
                    )
                )
            }
            if permissions.allows(Issue.Permissions.delete) {
                actions.append(
                    .init(
                        label: "Remove",
                        href: routes.issueRemovePath(
                            newsletterId: newsletterId,
                            issueId: issueId
                        ),
                        style: .destructive,
                    )
                )
            }
            return Section {
                context.build(
                    AdminBreadcrumb(links: routes.campaignBreadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit campaign",
                            description:
                                "Update the campaign settings."
                        )
                    )
                )
                context.build(
                    Campaign.Tabs(id: newsletterId, active: .issues)
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Issue content",
                            description:
                                "Review the subject, message, and delivery schedule."
                        )
                    ) {
                        Div {
                            context.build(
                                AdminDetailField(
                                    label: "Subject",
                                    value: model.subject
                                )
                                .setAsRemoveConfirmationLabel()
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Content",
                                    value: model.content
                                )
                            )
                            context.build(
                                AdminDetailField(
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
                                    let button = AdminButton(
                                        action.label,
                                        href: action.href,
                                        style: action.style,
                                    )
                                    context.build(button)
                                }
                            }
                            .class("admin-detail-actions")
                            .style(
                                "display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;"
                            )
                        }
                    }
                )
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
}
