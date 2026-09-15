import FeatherAdmin
import HTML
import OpenAPIRuntime
import WebBuilders
import WebComponents

struct WebMenuItemForm: Component {

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
                        name: state.label.key,
                        label: state.label.label,
                        value: state.label.value,
                        error: state.label.error,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.url.key,
                        label: state.url.label,
                        value: state.url.value,
                        error: state.url.error,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.priority.key,
                        label: state.priority.label,
                        value: state.priority.value,
                        error: state.priority.error,
                        type: .number,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldCheckbox(
                    state: .init(
                        name: state.isBlank.key,
                        label: "Link target",
                        checkboxLabel: "Open link in a new tab",
                        isChecked: state.isBlank.value,
                        error: state.isBlank.error
                    )
                )
            )
            context.render(
                NewAdminAutocompleteField(
                    state: .init(
                        name: state.permission.key,
                        label: state.permission.label,
                        placeholder: "Select a system permission...",
                        options: permissionOptions,
                        error: state.permission.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldSelect(
                    state: .init(
                        name: state.authentication.key,
                        label: state.authentication.label,
                        value: state.authentication.value,
                        options: [
                            .init(label: "Everyone", value: "any"),
                            .init(label: "Anonymous users", value: "anonymous"),
                            .init(
                                label: "Signed-in users",
                                value: "authenticated"
                            ),
                        ],
                        error: state.authentication.error,
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
        return context.render(form)
    }

    private var permissionOptions: [NewAdminAutocompleteField.Option] {
        let selectedValue = state.permission.value ?? ""
        var options = [
            NewAdminAutocompleteField.Option(
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
