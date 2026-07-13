import HTML
import SGML
import WebStandards

struct NewsletterForm: Component, FlowContent {
    struct State: Object {
        var name: String
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
            Section { Div { Button(submitLabel).type(.submit) }.class("button-row") }
        }.encType(.urlencoded).method(.post).action(action).class("cms-form")
    }
}
