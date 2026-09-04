import CSS
import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebMenuItemForm: Leaf {

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
        var permissionOptions: [String] = []
        var authentication: FieldState
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
            authentication.error = errors[authentication.key]
            notes.error = errors[notes.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func html() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.label.key,
                label: state.label.label,
                value: state.label.value,
                error: state.label.error,
                isRequired: true
            ).html()
            FormInputField(
                name: state.url.key,
                label: state.url.label,
                value: state.url.value,
                error: state.url.error,
                isRequired: true
            ).html()
            FormInputField(
                name: state.priority.key,
                label: state.priority.label,
                value: state.priority.value,
                error: state.priority.error,
                isRequired: true
            ).html()
            checkbox(state.isBlank)
            AdminAutocompleteField(
                state: .init(
                    key: state.permission.key,
                    label: state.permission.label,
                    placeholder: "Select a system permission...",
                    options: permissionOptions,
                    error: state.permission.error,
                    selectionMode: .single,
                    isEnabled: true
                )
            ).html()
            FormSelectField(
                name: state.authentication.key,
                label: state.authentication.label,
                options: [
                    .init(label: "Everyone", value: "any"),
                    .init(label: "Anonymous users", value: "anonymous"),
                    .init(label: "Signed-in users", value: "authenticated"),
                ],
                selectedValue: state.authentication.value,
                error: state.authentication.error,
                isRequired: true
            ).html()
            textarea(state.notes).html()

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        ).html()
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
        _ field: FieldState
    ) -> FormTextAreaField {
        FormTextAreaField(
            name: field.key,
            label: field.label,
            value: field.value,
            error: field.error,
            rows: 6
        )
    }

    private func checkbox(
        _ field: CheckboxState
    ) -> Section {
        Section {
            CheckboxField(
                state: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                )
            ).html()
        }
    }

    private var permissionOptions: [AdminAutocompleteField.OptionState] {
        let selectedValue = state.permission.value ?? ""
        var options = [
            AdminAutocompleteField.OptionState(
                label: "No permission",
                value: "",
                isSelected: selectedValue.isEmpty
            )
        ]
        let availablePermissions = Set(state.permissionOptions)
        options += state.permissionOptions.map {
            .init(
                label: $0,
                value: $0,
                isSelected: $0 == selectedValue
            )
        }
        if !selectedValue.isEmpty,
            !availablePermissions.contains(selectedValue)
        {
            options.append(
                .init(
                    label: "\(selectedValue) (unavailable)",
                    value: selectedValue,
                    isSelected: true
                )
            )
        }
        return options
    }
}
