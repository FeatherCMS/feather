import CSS
import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct UserRoleForm: Leaf {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var id: FieldState?
        var name: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            if let id {
                self.id?.error = errors[id.key]
            }
            name.error = errors[name.key]
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

            if let id = state.id {
                FormInputField(
                    name: id.key,
                    label: id.label,
                    value: id.value,
                    error: id.error,
                    isRequired: true
                ).renderHTML()
            }

            FormInputField(
                name: state.name.key,
                label: state.name.label,
                value: state.name.value,
                error: state.name.error
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
