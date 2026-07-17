import CSS
import HTML
import SGML
import WebStandards

struct AuthSettingsForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var language: FieldState
        var timezone: FieldState
        var pageSize: FieldState
        var canEdit: Bool
        var error: String?
        var success: String?
    }

    var state: State
    var action: String = "/admin/auth/settings/"
    var submitLabel: String = "Save settings"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.language.key,
                label: state.language.label,
                value: state.language.value,
                error: state.language.error,
                placeholder: "Language code, e.g. en",
                isRequired: true,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )

            FormInputField(
                name: state.timezone.key,
                label: state.timezone.label,
                value: state.timezone.value,
                error: state.timezone.error,
                placeholder: "Timezone, e.g. Europe/Budapest",
                isRequired: true,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )

            Section {
                Label {
                    AdminFieldLabel(label: state.pageSize.label, required: true)

                    Select {
                        for size in [10, 20, 50, 100] {
                            let value = "\(size)"
                            if state.pageSize.value == value {
                                Option(value)
                                    .value(value)
                                    .selected()
                            }
                            else {
                                Option(value)
                                    .value(value)
                            }
                        }
                    }
                    .id(state.pageSize.key)
                    .name(state.pageSize.key)
                    .class("text-input", "page-size-select")
                    .if(!state.canEdit) {
                        $0.disabled()
                    }
                }
                if let error = state.pageSize.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.pageSize.error != nil) { $0.class("has-error") }

            if state.canEdit {
                Section {
                    Div {
                        Button(submitLabel)
                            .type(.submit)
                    }
                    .class("button-row")
                }
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }
}
