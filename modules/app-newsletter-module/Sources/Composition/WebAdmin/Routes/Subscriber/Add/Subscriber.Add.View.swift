import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add {
    struct View: Component {
        let model: Model
        let isAdded: Bool
        let routes: Subscriber.Router.Routes
        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: routes.breadcrumb + [
                            .init(
                                label: "Subscribers",
                                link: routes.list.path
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
                    action: routes.add.path
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
}
