import FeatherWebAdmin
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
                AdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Subscribers",
                            link: NewsletterAdminRoutes.subscribers.description
                        )
                    ]
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add subscriber",
                        description: "Create a newsletter subscriber."
                    )
                )
            )
            let form = AdminForm(
                action: NewsletterAdminRoutes.subscriberAdd.description
            ) {
                if let error = model.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminFormFieldInput(
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
                    AdminFormFieldInput(
                        state: .init(
                            name: "firstName",
                            label: "First name",
                            value: model.firstName
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "lastName",
                            label: "Last name",
                            value: model.lastName
                        )
                    )
                )
                context.build(
                    AdminFormFieldSelectAutocomplete(
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
                        AdminSubmitButton("Add subscriber", style: .primary)
                    )
                }
                .class("admin-form__actions")
            }
            context.build(form)
        }
        .class("cms-section")
    }
}
