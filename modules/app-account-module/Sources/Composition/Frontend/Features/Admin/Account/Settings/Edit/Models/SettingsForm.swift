import FeatherWebAdmin
import HTML
import WebBuilders
import WebComponents

struct SettingsForm: Component {

    struct FieldState: FeatherWebAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherWebAdmin.Object {
        var language: FieldState
        var timezone: FieldState
        var pageSize: FieldState
        var canEdit: Bool
        var error: String?
        var success: String?
        var nonceToken: String? = nil
    }

    var state: State
    var action: String = "/admin/account/settings/"
    var submitLabel: String = "Save settings"

    func html(context: inout BuilderContext) -> Form {
        let form = AdminForm(action: action, nonceToken: state.nonceToken) {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("admin-form__error")
            }

            context.build(
                AdminFormFieldLanguage(
                    state: .init(
                        name: state.language.key,
                        label: state.language.label,
                        values: state.language.value.map { [$0] } ?? [],
                        error: state.language.error,
                        isRequired: true,
                        isDisabled: !state.canEdit,
                        selectionMode: .single
                    )
                )
            )

            context.build(
                AdminFormFieldTimezone(
                    state: .init(
                        name: state.timezone.key,
                        label: state.timezone.label,
                        value: state.timezone.value,
                        error: state.timezone.error,
                        isRequired: true,
                        isDisabled: !state.canEdit
                    )
                )
            )

            context.build(
                AdminFormFieldPaginationLimit(
                    state: .init(
                        name: state.pageSize.key,
                        label: state.pageSize.label,
                        value: state.pageSize.value,
                        error: state.pageSize.error,
                        isRequired: true,
                        isDisabled: !state.canEdit
                    )
                )
            )

            if state.canEdit {
                Section {
                    Div {
                        context.build(AdminSubmitButton(submitLabel))
                    }
                    .class("admin-form__actions")
                }
            }
        }
        return context.build(form)
    }
}
