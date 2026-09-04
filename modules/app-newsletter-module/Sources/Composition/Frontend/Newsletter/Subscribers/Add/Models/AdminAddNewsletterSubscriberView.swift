import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterSubscriberView: Leaf {
    let model: AdminAddNewsletterSubscriberModel
    let isAdded: Bool
    let breadcrumb: AdminBreadcrumb.State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).renderHTML()
            H1("Add subscriber")
            if isAdded { P("Subscriber added successfully.") }
            if let error = model.error { P(error).class("error") }
            Form {
                Label {
                    AdminFieldLabel(label: "Email", required: true).renderHTML()
                    Input().type(.email).class("text-input").name("email")
                        .value(model.email).required()
                }
                Label {
                    AdminFieldLabel(label: "First name", required: false).renderHTML()
                    Input().type(.text).class("text-input").name("firstName")
                        .value(model.firstName)
                }
                Label {
                    AdminFieldLabel(label: "Last name", required: false).renderHTML()
                    Input().type(.text).class("text-input").name("lastName")
                        .value(model.lastName)
                }
                AdminAutocompleteField(
                    state: .init(
                        key: "campaignIds",
                        label: "Campaigns",
                        placeholder: "Select campaigns",
                        options: model.campaigns.map {
                            .init(
                                label: $0.name,
                                value: $0.id,
                                isSelected: model.selectedCampaignIds.contains(
                                    $0.id
                                )
                            )
                        },
                        error: nil,
                        selectionMode: .multiple,
                        isEnabled: true
                    )
                ).renderHTML()
                Div { Button("Add subscriber").type(.submit) }
                    .class("button-row")
            }
            .method(.post).action("/admin/newsletters/subscribers/add/")
            .class("cms-form")
        }
        .class("cms-section")
    }
}
