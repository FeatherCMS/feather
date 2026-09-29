import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscriberFormView: Component {
    struct State {
        let newsletterId: String
        let email: String
        let firstName: String
        let lastName: String
        let status: String
        let isEdit: Bool
        let error: String?
        let editAction: String?
        let pageHeader: NewAdminPageHeader.State
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        let action =
            state.editAction
            ?? (state.isEdit
                ? NewsletterAdminRoutes.campaignSubscriberEdit(
                    newsletterID: RouterPath(state.newsletterId),
                    subscriberID: RouterPath(state.email)
                )
                .description
                : NewsletterAdminRoutes.campaignSubscriberAdd(
                    RouterPath(state.newsletterId)
                )
                .description)
        return Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaign subscribers",
                            link:
                                NewsletterAdminRoutes.campaignSubscribers(
                                    RouterPath(state.newsletterId)
                                )
                                .description
                        ),
                        .init(
                            label: state.isEdit ? "Edit" : "Add",
                            link: action
                        ),
                    ]
                )
            )
            context.build(NewAdminPageHeader(state: state.pageHeader))
            context.build(
                NewsletterCampaignTabs(
                    id: state.newsletterId,
                    active: .subscribers
                )
            )
            let form = NewAdminForm(action: action) {
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "email",
                            label: "Email",
                            value: state.email,
                            type: .email,
                            isRequired: true,
                            isReadOnly: state.isEdit
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "firstName",
                            label: "First name",
                            value: state.firstName
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "lastName",
                            label: "Last name",
                            value: state.lastName
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldSelect(
                        state: .init(
                            name: "status",
                            label: "Status",
                            value: state.status,
                            options: [
                                .init(label: "Subscribed", value: "subscribed"),
                                .init(
                                    label: "Unsubscribed",
                                    value: "unsubscribed"
                                ),
                            ],
                            isRequired: true
                        )
                    )
                )
                Div {
                    context.build(
                        NewAdminSubmitButton(
                            state.isEdit ? "Save subscriber" : "Add subscriber",
                            style: .primary
                        )
                    )
                }
                .class("new-admin-form__actions")
            }
            context.build(
                NewAdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Subscriber details",
                        description:
                            "Manage this subscriber’s information and campaign status."
                    )
                ) {
                    context.build(form)
                }
            )
        }
        .class("cms-section")
    }
}
