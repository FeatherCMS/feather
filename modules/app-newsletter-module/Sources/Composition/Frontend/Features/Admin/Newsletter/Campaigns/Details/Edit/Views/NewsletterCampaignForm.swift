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

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "name",
                        label: "Name",
                        value: state.name,
                        isRequired: true
                    )
                )
            )
            context.build(
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
                context.build(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
