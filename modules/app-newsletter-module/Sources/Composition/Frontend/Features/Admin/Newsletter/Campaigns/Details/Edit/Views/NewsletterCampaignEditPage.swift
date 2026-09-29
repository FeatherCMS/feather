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
        let pageHeader: NewAdminPageHeader.State
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
            context.build(NewAdminPageHeader(state: state.pageHeader))
            context.build(
                NewsletterCampaignTabs(id: state.id, active: .details)
            )
            if state.isDetails {
                context.build(
                    NewAdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Campaign details",
                            description: "Review the campaign configuration."
                        )
                    ) {
                        Div {
                            context.build(
                                NewAdminDetailField(
                                    label: "Key",
                                    value: state.form.key
                                )
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
                        .style(
                            "display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;"
                        )
                    }
                )
            }
            else {
                context.build(
                    NewAdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Campaign configuration",
                            description:
                                "Update the campaign key, name, and sender address."
                        )
                    ) {
                        context.build(
                            NewsletterCampaignForm(
                                state: state.form,
                                action: editPath,
                                submitLabel: "Save campaign"
                            )
                        )
                    }
                )
            }
        }
        .class("cms-section")
    }
}
