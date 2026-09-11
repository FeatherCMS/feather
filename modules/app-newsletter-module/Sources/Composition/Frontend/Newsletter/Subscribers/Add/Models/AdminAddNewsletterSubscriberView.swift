import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriberView: Component {
    let model: AdminAddNewsletterSubscriberModel
    let isAdded: Bool
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Add subscriber")
            if isAdded { P("Subscriber added successfully.") }
            if let error = model.error { P(error).class("error") }
            Form {
                Label {
                    context.render(
                        AdminFieldLabel(label: "Email", required: true)
                    )
                    Input().type(.email).class("text-input").name("email")
                        .value(model.email).required()
                }
                Label {
                    context.render(
                        AdminFieldLabel(label: "First name", required: false)
                    )
                    Input().type(.text).class("text-input").name("firstName")
                        .value(model.firstName)
                }
                Label {
                    context.render(
                        AdminFieldLabel(label: "Last name", required: false)
                    )
                    Input().type(.text).class("text-input").name("lastName")
                        .value(model.lastName)
                }
                context.render(
                    AdminAutocompleteField(
                        state: .init(
                            key: "campaignIds",
                            label: "Campaigns",
                            placeholder: "Select campaigns",
                            options: model.campaigns.map {
                                .init(
                                    label: $0.name,
                                    value: $0.id,
                                    isSelected: model.selectedCampaignIds
                                        .contains(
                                            $0.id
                                        )
                                )
                            },
                            error: nil,
                            selectionMode: .multiple,
                            isEnabled: true
                        )
                    )
                )
                Div { Button("Add subscriber").type(.submit) }
                    .class("button-row")
            }
            .method(.post).action("/admin/newsletters/subscribers/add/")
            .class("cms-form")
        }
        .class("cms-section")
    }
}
