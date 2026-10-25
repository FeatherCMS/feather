import FeatherWebAdmin
import HTML
import RedirectDomain
import RedirectApplication
import RedirectModule
import WebBuilders
import WebComponents

extension Rule.Edit {
    struct Form: Component {
        struct State: Sendable {
            var source: AdminFormFieldInput.State
            var destination: AdminFormFieldInput.State
            var statusCode: AdminFormFieldSelect.State
            var notes: AdminFormFieldTextArea.State
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

            static func from(input: Input) -> Self {
                var state = Self.empty()
                state.source.value = input.normalizedSource
                state.destination.value = input.normalizedDestination
                state.statusCode.value = input.normalizedStatusCode
                state.notes.value = input.normalizedNotes
                return state
            }

            static func from(rule: Model) -> Self {
                var state = Self.empty()
                state.source.value = rule.source
                state.destination.value = rule.destination
                state.statusCode.value = String(rule.statusCode.rawValue)
                state.notes.value = rule.notes ?? ""
                return state
            }

            private static let statusOptions = [
                AdminFormFieldSelect.SelectOption(
                    label: "301 Moved Permanently",
                    value: "301"
                ),
                AdminFormFieldSelect.SelectOption(
                    label: "302 Found",
                    value: "302"
                ),
                AdminFormFieldSelect.SelectOption(
                    label: "307 Temporary Redirect",
                    value: "307"
                ),
                AdminFormFieldSelect.SelectOption(
                    label: "308 Permanent Redirect",
                    value: "308"
                ),
            ]
        }

        let state: State
        let action: String
        let viewHref: String?
        let removeHref: String?
        let nonceToken: String?

        func html(context: inout BuilderContext) -> HTML.Form {
            let form = AdminForm(action: action, nonceToken: nonceToken) {
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(AdminFormFieldInput(state: state.source))
                context.build(AdminFormFieldInput(state: state.destination))
                context.build(AdminFormFieldSelect(state: state.statusCode))
                context.build(AdminFormFieldTextArea(state: state.notes))
                Div {
                    context.build(
                        AdminSubmitButton("Save changes", style: .primary)
                    )
                    if let viewHref {
                        context.build(
                            AdminButton(
                                "View",
                                href: viewHref,
                                style: .secondary
                            )
                        )
                    }
                    if let removeHref {
                        context.build(
                            AdminButton(
                                "Remove",
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
