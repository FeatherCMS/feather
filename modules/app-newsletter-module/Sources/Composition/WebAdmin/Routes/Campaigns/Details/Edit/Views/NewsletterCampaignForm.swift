import FeatherWebAdmin
import HTML
import WebBuilders
import WebComponents

struct NewsletterCampaignForm: Component {
    struct State {
        let key: String
        let name: String
        let fromEmail: String
        let error: String?
        let success: String?
    }

    let state: State
    let action: String
    let submitLabel: String

    func html(context: inout BuilderContext) -> Form {
        let form = AdminForm(action: action) {
            if let error = state.error {
                P(error).class("admin-form__error")
            }
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "key",
                        label: "Key",
                        value: state.key,
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "name",
                        label: "Name",
                        value: state.name,
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "fromEmail",
                        label: "From email",
                        value: state.fromEmail,
                        type: .email,
                        isRequired: true
                    )
                )
            )
            Div {
                context.build(
                    AdminSubmitButton(submitLabel, style: .primary)
                )
            }
            .class("admin-form__actions")
        }
        return context.build(form)
    }
}
