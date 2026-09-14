import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct NewsletterCampaignForm: Component {
    struct State {
        let name: String
        let fromEmail: String
        let error: String?
        let success: String?
    }

    let state: State
    let action: String
    let submitLabel: String

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "name",
                        label: "Name",
                        value: state.name,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
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
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
            }
            .class("new-admin-form__actions")
        }
        context.register(form)
        return form.html(context: &context)
    }
}
