import CSS
import HTML
import SGML
import WebStandards

struct UserAccountForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var isRequired: Bool
        var value: String?
        var error: String?
    }

    struct RoleOptionState: Object {
        var key: String
        var label: String
        var value: String
        var isSelected: Bool
    }

    struct State: Object {
        var email: FieldState
        var password: FieldState
        var roleOptions: [RoleOptionState]
        var roleIdsError: String?
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.key]
            password.error = errors[password.key]
            roleIdsError = errors["roleIds"] ?? errors["roleIds[]"]
        }
    }

    var state: State
    var action: String = "/admin/user/accounts/add/"
    var submitLabel: String = "Add account"
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            Section {
                Label {
                    AdminFieldLabel(
                        label: state.email.label,
                        required: state.email.isRequired
                    )

                    Input()
                        .type(.text)
                        .class("text-input")
                        .id(state.email.key)
                        .name(state.email.key)
                        .value(state.email.value)
                }
                if let error = state.email.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.email.error != nil) { $0.class("has-error") }

            Section {
                Label {
                    AdminFieldLabel(
                        label: state.password.label,
                        required: state.password.isRequired
                    )

                    Input()
                        .type(.password)
                        .class("text-input")
                        .id(state.password.key)
                        .name(state.password.key)
                        .value(state.password.value)
                }
                if let error = state.password.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.password.error != nil) { $0.class("has-error") }

            if !state.roleOptions.isEmpty {
                Section {
                    AdminFieldLabel(label: "Roles", required: false)
                    Div {
                        for option in state.roleOptions {
                            Label {
                                Input()
                                    .type(.checkbox)
                                    .name(option.key)
                                    .value(option.value)
                                    .if(option.isSelected) { $0.checked() }
                                InlineText(option.label)
                            }
                            .class("multi-option")
                        }
                    }
                    .class("checkbox-multiselect")
                    if let error = state.roleIdsError {
                        Span(error).class("field-error")
                    }
                }
                .if(state.roleIdsError != nil) { $0.class("has-error") }
            }

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        )
                    }
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }
}
