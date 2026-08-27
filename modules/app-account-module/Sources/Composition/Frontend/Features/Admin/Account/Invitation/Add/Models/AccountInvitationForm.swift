import CSS
import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AccountInvitationForm: Component, FlowContent {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var email: FieldState
        var roleIds: FieldState
        var roleOptions: [RoleOptionState]
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.key]
            roleIds.error = errors[roleIds.key]
        }
    }

    struct RoleOptionState: FeatherAdmin.Object {
        var value: String
        var label: String
        var isSelected: Bool
    }

    var state: State
    var action: String
    var submitLabel: String
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

            FormInputField(
                name: state.email.key,
                label: state.email.label,
                value: state.email.value,
                error: state.email.error,
                isRequired: true
            )
            Section {
                if state.roleOptions.isEmpty {
                    P("No roles available.")
                }
                else {
                    AdminFieldLabel(label: "Roles", required: false)
                    Div {
                        for option in state.roleOptions {
                            Label {
                                Input()
                                    .type(.checkbox)
                                    .name("roleIds[]")
                                    .value(option.value)
                                    .if(option.isSelected) { $0.checked() }
                                InlineText(option.label)
                            }
                            .class("multi-option")
                        }
                    }
                    .class("checkbox-multiselect")
                    if let error = state.roleIds.error {
                        Span(error).class("field-error")
                    }
                }
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
