import HTML
import SGML
import WebStandards

struct ContactFormForm: Component, FlowContent {
    struct State: Object {
        var name: String
        var successMessage: String
        var failureMessage: String
        var redirectUrl: String?
        var fieldIDs: Set<String>
        var availableFields: [AdminManageContactFormFieldOption]
        var mails: [AdminManageContactFormMail]
        var error: String?
        var success: String?
    }

    var state: State
    var action: String
    var submitLabel: String

    func content() -> some BasicTag {
        Form {
            if let success = state.success { P(success).class("success") }
            if let error = state.error { P(error).class("error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Name", required: true)
                    Input().type(.text).id("name").name("name").value(state.name).required()
                }
            }.if(state.error != nil) { $0.class("has-error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Success message", required: false)
                    Input().type(.text).id("successMessage").name("successMessage").value(state.successMessage)
                }
                Label {
                    AdminFieldLabel(label: "Failure message", required: false)
                    Input().type(.text).id("failureMessage").name("failureMessage").value(state.failureMessage)
                }
                Label {
                    AdminFieldLabel(label: "Redirect URL", required: false)
                    Input().type(.text).id("redirectUrl").name("redirectUrl").value(state.redirectUrl ?? "")
                }
            }
            if !state.availableFields.isEmpty {
                Section {
                    AdminFieldLabel(label: "Fields", required: false)
                    Div {
                        for field in state.availableFields {
                            Label {
                                Input()
                                    .type(.checkbox)
                                    .name("fieldIds[]")
                                    .value(field.id)
                                    .if(state.fieldIDs.contains(field.id)) { $0.checked() }
                                InlineText(field.label)
                            }
                            .class("multi-option")
                        }
                    }
                    .class("checkbox-multiselect")
                }
            }
            Section { Div { Button(submitLabel).type(.submit) }.class("button-row") }
        }.encType(.urlencoded).method(.post).action(action).class("cms-form")
    }
}
