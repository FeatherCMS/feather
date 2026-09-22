import FeatherAdmin
import HTML
import WebComponents
import WebBuilders

struct AccountInvitationForm: Component {

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
        var nonceToken: String? = nil

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

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: state.nonceToken) {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }

            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.email.key,
                        label: state.email.label,
                        value: state.email.value,
                        error: state.email.error,
                        isRequired: true
                    )
                )
            )
            if state.roleOptions.isEmpty {
                P("No roles available.")
            }
            else {
                context.build(
                    NewAdminFormFieldCheckboxGroup(
                        name: "roleIds[]",
                        label: "Roles",
                        options: state.roleOptions.map {
                            .init(
                                label: $0.label,
                                value: $0.value,
                                isSelected: $0.isSelected
                            )
                        },
                        error: state.roleIds.error
                    )
                )
            }

            Section {
                Div {
                    context.build(NewAdminSubmitButton(submitLabel))
                    if let removeHref {
                        context.build(
                            NewAdminButton(
                                removeLabel,
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        }
        return context.build(form)
    }
}
