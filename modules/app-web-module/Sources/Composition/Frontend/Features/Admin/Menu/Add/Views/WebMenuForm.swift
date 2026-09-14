import FeatherAdmin
import HTML
import OpenAPIRuntime
import WebBuilders
import WebComponents

struct WebMenuForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var key: FieldState
        var name: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            key.error = errors[key.key]
            name.error = errors[name.key]
            notes.error = errors[notes.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let success = state.success {
                P(success).class("new-admin-form__success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }

            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                    name: state.key.key,
                    label: state.key.label,
                    value: state.key.value,
                    error: state.key.error,
                    isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                    name: state.name.key,
                    label: state.name.label,
                    value: state.name.value,
                    error: state.name.error,
                    isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: state.notes.key,
                        label: state.notes.label,
                        value: state.notes.value,
                        error: state.notes.error,
                        style: .small
                    )
                )
            )

            Div {
                Div {
                    context.render(NewAdminSubmitButton(submitLabel))
                    if let removeHref {
                        context.render(
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
        context.register(form)
        return form.html(context: &context)
    }
}
