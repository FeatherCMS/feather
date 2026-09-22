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

    func html(context: inout BuilderContext) -> some BasicTag {
        let editPath = NewsletterAdminRoutes.campaignEdit(RouterPath(state.id))
            .description
        return Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaigns",
                            link: NewsletterAdminRoutes.campaigns.description
                        )
                    ]
                )
            )
            context.build(
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
            context.build(
                NewAdminTabBar(links: [
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
                        P("Key")
                        P(state.form.key)
                    }
                    .class("admin-detail-view-field")
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
                    context.build(
                        NewAdminButton("Edit", href: editPath, style: .primary)
                    )
                }
                .class("new-admin-detail-actions")
            }
            else {
                context.build(
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
