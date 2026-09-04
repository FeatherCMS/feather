import CSS
import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct SystemVariableForm: Leaf {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var id: FieldState
        var name: FieldState
        var value: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            id.error = errors[id.key]
            name.error = errors[name.key]
            value.error = errors[value.key]
            notes.error = errors[notes.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func renderHTML() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.id.key,
                label: state.id.label,
                value: state.id.value,
                error: state.id.error,
                isRequired: true
            ).renderHTML()

            FormInputField(
                name: state.name.key,
                label: state.name.label,
                value: state.name.value,
                error: state.name.error,
                isRequired: true
            ).renderHTML()

            FormInputField(
                name: state.value.key,
                label: state.value.label,
                value: state.value.value,
                error: state.value.error,
                isRequired: true
            ).renderHTML()

            FormInputField(
                name: state.notes.key,
                label: state.notes.label,
                value: state.notes.value,
                error: state.notes.error
            ).renderHTML()

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        ).renderHTML()
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
