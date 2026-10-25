import AccountModule
import FeatherWebAdmin
import HTML
import WebBuilders
import WebComponents

extension Invitation.Form {
    struct Component: WebComponents.Component {

        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct State: Sendable {
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

        struct RoleOptionState: Sendable {
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
            let form = AdminForm(action: action, nonceToken: state.nonceToken) {
                if let success = state.success {
                    P(success).class("success")
                }
                if let error = state.error {
                    P(error).class("admin-form__error")
                }

                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: state.email.key,
                            label: state.email.label,
                            value: state.email.value,
                            error: state.email.error,
                            isRequired: true
                        )
                    )
                    .setAsRemoveConfirmationLabel()
                )
                if state.roleOptions.isEmpty {
                    P("No roles available.")
                }
                else {
                    context.build(
                        AdminFormFieldCheckboxGroup(
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
                        context.build(AdminSubmitButton(submitLabel))
                        if let removeHref {
                            context.build(
                                AdminButton(
                                    removeLabel,
                                    href: removeHref,
                                    style: .destructive
                                )
                            )
                        }
                    }
                    .class("admin-form__actions")
                }
            }
            return context.build(form)
        }
    }
}
