import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignEditPage: Component {
    struct State {
        let id: String
        let form: NewsletterCampaignForm.State
        let isDetails: Bool
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let editPath = NewsletterAdminRoutes.campaignEdit(RouterPath(state.id))
            .description
        return Section {
            context.render(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaigns",
                            link: NewsletterAdminRoutes.campaigns.description
                        )
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: state.isDetails
                            ? "Campaign details" : "Edit campaign",
                        description: state.isDetails
                            ? "View this newsletter campaign."
                            : "Update this newsletter campaign."
                    )
                )
            )
            context.render(
                NewAdminPillTab(links: [
                    .init(
                        label: "Details",
                        href:
                            NewsletterAdminRoutes.campaignDetails(
                                RouterPath(state.id)
                            )
                            .description,
                        isCurrent: true
                    ),
                    .init(
                        label: "Subscribers",
                        href:
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(state.id)
                            )
                            .description,
                        isCurrent: false
                    ),
                    .init(
                        label: "Issues",
                        href:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(state.id)
                            )
                            .description,
                        isCurrent: false
                    ),
                ])
            )
            if state.isDetails {
                Div {
                    Div {
                        P("Name")
                        P(state.form.name)
                    }
                    .class("admin-detail-view-field")
                    Div {
                        P("From email")
                        P(state.form.fromEmail)
                    }
                    .class("admin-detail-view-field")
                }
                .class("admin-detail-view-fields")
                Div {
                    context.render(
                        NewAdminButton("Edit", href: editPath, style: .primary)
                    )
                }
                .class("new-admin-detail-actions")
            }
            else {
                context.render(
                    NewsletterCampaignForm(
                        state: state.form,
                        action: editPath,
                        submitLabel: "Save campaign"
                    )
                )
            }
        }
        .class("cms-section")
    }
}
