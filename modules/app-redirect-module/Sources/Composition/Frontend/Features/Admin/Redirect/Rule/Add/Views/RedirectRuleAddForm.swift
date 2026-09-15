import FeatherAdmin
import HTML
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleAddForm: Component {
    struct State: Sendable {
        var source: NewAdminFormFieldInput.State
        var destination: NewAdminFormFieldInput.State
        var statusCode: NewAdminFormFieldSelect.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            source.error = errors[source.name]
            destination.error = errors[destination.name]
            statusCode.error = errors[statusCode.name]
            notes.error = errors[notes.name]
        }

        static func empty() -> Self {
            .init(
                source: .init(
                    name: "source",
                    label: "Source path",
                    isRequired: true
                ),
                destination: .init(
                    name: "destination",
                    label: "Destination URL or path",
                    isRequired: true
                ),
                statusCode: .init(
                    name: "statusCode",
                    label: "HTTP status code",
                    value: "301",
                    options: statusOptions,
                    isRequired: true
                ),
                notes: .init(name: "notes", label: "Notes", style: .small),
                error: nil
            )
        }

        static func from(input: RedirectRuleAddFormInput) -> Self {
            var state = Self.empty()
            state.source.value = input.normalizedSource
            state.destination.value = input.normalizedDestination
            state.statusCode.value = input.normalizedStatusCode
            state.notes.value = input.normalizedNotes
            return state
        }

        private static let statusOptions = [
            NewAdminFormFieldSelect.SelectOption(
                label: "301 Moved Permanently",
                value: "301"
            ),
            NewAdminFormFieldSelect.SelectOption(
                label: "302 Found",
                value: "302"
            ),
            NewAdminFormFieldSelect.SelectOption(
                label: "307 Temporary Redirect",
                value: "307"
            ),
            NewAdminFormFieldSelect.SelectOption(
                label: "308 Permanent Redirect",
                value: "308"
            ),
        ]
    }

    let state: State
    let action: String
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(NewAdminFormFieldInput(state: state.source))
            context.build(NewAdminFormFieldInput(state: state.destination))
            context.build(NewAdminFormFieldSelect(state: state.statusCode))
            context.build(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.build(
                    NewAdminSubmitButton("Add rule", style: .primary)
                )
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
