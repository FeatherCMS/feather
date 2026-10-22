import FeatherWebAdmin
import HTML
import MediaAdminAPI
import WebBuilders
import WebComponents

struct MediaVariantProcessorFormTokens: Sendable {
    let edit: String
    let remove: String
}

struct MediaVariantProcessorFormView: Component {
    let processor:
        MediaAdminAPI.Components.Schemas.MediaVariantProcessorQueryItemSchema?
    let action: String
    let nonceToken: String

    func html(context: inout BuilderContext) -> Form {
        let isNew = processor == nil
        let form = AdminForm(action: action, nonceToken: nonceToken) {
            H3(isNew ? "Add processor" : "Edit \(processor?.name ?? "")")
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "name",
                        label: "Processor",
                        value: processor?.name ?? "",
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "matchExtensions",
                        label: "Input extensions",
                        value: processor?.matchExtensions ?? "",
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldTextArea(
                    state: .init(
                        name: "commandTemplate",
                        label: "Command template",
                        value: processor?.commandTemplate ?? "",
                        style: .small,
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldCheckbox(
                    state: .init(
                        name: "isActive",
                        label: "Status",
                        checkboxLabel: "Active processor",
                        isChecked: processor?.isActive ?? true
                    )
                )
            )
            context.build(
                AdminSubmitButton(
                    isNew ? "Add processor" : "Save processor",
                    style: .primary
                )
            )
        }
        return context.build(form)
    }
}
