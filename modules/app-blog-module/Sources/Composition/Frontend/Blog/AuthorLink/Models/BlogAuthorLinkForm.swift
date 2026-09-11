import BlogAdminAPI
import BlogAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorLinkForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var label: FieldState
        var url: FieldState
        var priority: FieldState
        var isBlank: CheckboxState
        var permission: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            label.error = errors[label.key]
            url.error = errors[url.key]
            priority.error = errors[priority.key]
            isBlank.error = errors[isBlank.key]
            permission.error = errors[permission.key]
            notes.error = errors[notes.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func html(context: inout RenderContext) -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            context.render(
                FormInputField(
                    name: state.label.key,
                    label: state.label.label,
                    value: state.label.value,
                    error: state.label.error,
                    isRequired: true
                )
            )
            context.render(
                FormInputField(
                    name: state.url.key,
                    label: state.url.label,
                    value: state.url.value,
                    error: state.url.error,
                    isRequired: true
                )
            )
            context.render(
                FormInputField(
                    name: state.priority.key,
                    label: state.priority.label,
                    value: state.priority.value,
                    error: state.priority.error,
                    isRequired: true
                )
            )
            checkbox(state.isBlank)
            context.render(
                FormInputField(
                    name: state.permission.key,
                    label: state.permission.label,
                    value: state.permission.value,
                    error: state.permission.error
                )
            )
            textarea(state.notes, context: &context)

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        context.render(
                            AdminNavigationButton(
                                removeLabel,
                                href: removeHref,
                                classes: ["danger"]
                            )
                        )
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

    private func textarea(
        _ field: FieldState,
        context: inout RenderContext
    ) -> FormTextAreaField {

        context.render(
            FormTextAreaField(
                name: field.key,
                label: field.label,
                value: field.value,
                error: field.error,
                rows: 6
            )
        )
    }

    private func checkbox(
        _ field: CheckboxState
    ) -> some BasicTag {
        Section {
            CheckboxField(
                state: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                )
            )
        }
    }
}
