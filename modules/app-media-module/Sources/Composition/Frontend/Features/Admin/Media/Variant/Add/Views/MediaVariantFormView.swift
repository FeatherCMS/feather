import FeatherAdmin
import HTML
import MediaAdminAPI
import SGML
import WebBuilders
import WebComponents

struct MediaVariantFormView: Component {
    struct State: Sendable {
        var key: NewAdminFormFieldInput.State
        var name: NewAdminFormFieldInput.State
        var isRequired: NewAdminFormFieldCheckbox.State
        var isActive: NewAdminFormFieldCheckbox.State
        var error: String?

        static func empty() -> Self {
            .init(
                key: .init(name: "key", label: "Key", value: "", isRequired: true),
                name: .init(name: "name", label: "Name", value: "", isRequired: true),
                isRequired: .init(name: "isRequired", label: "Generation", checkboxLabel: "Required variant", isChecked: false),
                isActive: .init(name: "isActive", label: "Status", checkboxLabel: "Active variant", isChecked: true),
                error: nil
            )
        }

        static func from(input: MediaVariantFormInput?) -> Self {
            guard let input else { return .empty() }
            return .init(
                key: .init(name: "key", label: "Key", value: input.normalizedKey, isRequired: true),
                name: .init(name: "name", label: "Name", value: input.normalizedName, isRequired: true),
                isRequired: .init(name: "isRequired", label: "Generation", checkboxLabel: "Required variant", isChecked: input.isRequired.value),
                isActive: .init(name: "isActive", label: "Status", checkboxLabel: "Active variant", isChecked: input.isActive.value),
                error: nil
            )
        }

        static func from(detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema) -> Self {
            .init(
                key: .init(name: "key", label: "Key", value: detail.key, isRequired: true),
                name: .init(name: "name", label: "Name", value: detail.name, isRequired: true),
                isRequired: .init(name: "isRequired", label: "Generation", checkboxLabel: "Required variant", isChecked: detail.isRequired),
                isActive: .init(name: "isActive", label: "Status", checkboxLabel: "Active variant", isChecked: detail.isActive),
                error: nil
            )
        }

        mutating func apply(errors: [String: String]) {
            key.error = errors[key.name]
            name.error = errors[name.name]
        }

        mutating func apply(error: String) { self.error = error }
    }

    let state: State
    let action: String
    let submitLabel: String
    let nonceToken: String?
    let viewHref: String?
    let removeHref: String?

    init(
        state: State,
        action: String,
        submitLabel: String,
        nonceToken: String?,
        viewHref: String? = nil,
        removeHref: String? = nil
    ) {
        self.state = state
        self.action = action
        self.submitLabel = submitLabel
        self.nonceToken = nonceToken
        self.viewHref = viewHref
        self.removeHref = removeHref
    }

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error { P(error).class("new-admin-form__error") }
            context.build(NewAdminFormFieldInput(state: state.key))
            context.build(NewAdminFormFieldInput(state: state.name))
            context.build(NewAdminFormFieldCheckbox(state: state.isRequired))
            context.build(NewAdminFormFieldCheckbox(state: state.isActive))
            Div {
                context.build(NewAdminSubmitButton(submitLabel, style: .primary))
                if let viewHref { context.build(NewAdminButton("View", href: viewHref, style: .secondary)) }
                if let removeHref { context.build(NewAdminButton("Remove", href: removeHref, style: .destructive)) }
            }.class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
