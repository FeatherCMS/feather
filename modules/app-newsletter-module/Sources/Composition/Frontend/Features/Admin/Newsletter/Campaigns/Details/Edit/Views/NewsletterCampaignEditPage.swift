import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignEditPage: Component {
    struct State {
        let id: String
        let form: NewsletterCampaignForm.State
        let isDetails: Bool
        let permissions: NewAdminListActions
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
                NewsletterCampaignHeader(
                    campaignId: state.id,
                    active: .details
                )
            )
            if state.isDetails {
                H2("Campaign details")
                Div {
                    context.build(
                        NewAdminDetailField(label: "Key", value: state.form.key)
                    )
                    context.build(
                        NewAdminDetailField(
                            label: "Name",
                            value: state.form.name
                        )
                    )
                    context.build(
                        NewAdminDetailField(
                            label: "From email",
                            value: state.form.fromEmail
                        )
                    )
                }
                .class("admin-detail-view-fields")
                .style("display:grid;gap:12px;")
                Div {
                    if state.permissions.allows(Permissions.Campaigns.update) {
                        context.build(
                            NewAdminButton(
                                "Edit",
                                href: editPath,
                                style: .primary
                            )
                        )
                    }
                    if state.permissions.allows(Permissions.Campaigns.delete) {
                        context.build(
                            NewAdminButton(
                                "Remove",
                                href: NewAdminLocation.remove(
                                    path: NewsletterAdminRoutes.campaignRemove
                                        .description,
                                    ids: [state.id],
                                    returnTo:
                                        NewsletterAdminRoutes.campaignDetails(
                                            RouterPath(state.id)
                                        )
                                        .description
                                ),
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-detail-actions")
                .style("display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;")
            }
            else {
                H2("Edit campaign")
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
