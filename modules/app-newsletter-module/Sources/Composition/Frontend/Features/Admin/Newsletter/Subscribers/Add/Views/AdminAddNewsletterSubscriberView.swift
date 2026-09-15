import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriberView: Component {
    let model: AdminAddNewsletterSubscriberModel
    let isAdded: Bool
    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: NewsletterAdminRoutes.subscribers.description
                        )
                    ]
                )
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add subscriber",
                        description: "Create a newsletter subscriber."
                    )
                )
            )
            let form = NewAdminForm(
                action: NewsletterAdminRoutes.subscriberAdd.description
            ) {
                if let error = model.error {
                    P(error).class("new-admin-form__error")
                }
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "email",
                            label: "Email",
                            value: model.email,
                            type: .email,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "firstName",
                            label: "First name",
                            value: model.firstName
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "lastName",
                            label: "Last name",
                            value: model.lastName
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldSelectAutocomplete(
                        state: .init(
                            name: "campaignIds[]",
                            label: "Campaigns",
                            placeholder: "Select campaigns",
                            options: model.campaigns.map {
                                .init(
                                    label: $0.name,
                                    value: $0.id,
                                    isSelected: model.selectedCampaignIds
                                        .contains($0.id)
                                )
                            },
                            selectionMode: .multiple
                        )
                    )
                )
                Div {
                    context.build(
                        NewAdminSubmitButton("Add subscriber", style: .primary)
                    )
                }
                .class("new-admin-form__actions")
            }
            context.build(form)
        }
        .class("cms-section")
    }
}
