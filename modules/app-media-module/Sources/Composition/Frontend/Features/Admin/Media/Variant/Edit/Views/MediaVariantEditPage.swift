import FeatherAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaVariantEditPage: Component {
    let id: String
    let detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    let form: MediaVariantFormView
    let processorTokens: [String: MediaVariantProcessorFormTokens]
    let addProcessorNonce: String
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: MediaVariantRoutes.breadcrumb))
            context.build(NewAdminPageHeader(state: .init(
                title: "Edit \(detail.name)",
                description: "Update the variant and manage its processors."
            )))
            context.build(form)
            H2("Processors")
            if detail.processors.isEmpty { P("No processors configured yet.").class("muted") }
            for processor in detail.processors {
                if permissions.allows(MediaPermissions.VariantProcessors.update) {
                    context.build(MediaVariantProcessorFormView(
                        processor: processor,
                        action: MediaVariantRoutes.processorEdit(RouterPath(id), processorId: RouterPath(processor.id)).description,
                        nonceToken: processorTokens[processor.id]?.edit ?? ""
                    ))
                }
                if permissions.allows(MediaPermissions.VariantProcessors.delete) {
                    context.build(NewAdminForm(action: MediaVariantRoutes.processorRemove(RouterPath(id)).description, nonceToken: processorTokens[processor.id]?.remove ?? "") {
                        Input().type(.hidden).name("ids").value(processor.id)
                        context.build(NewAdminSubmitButton("Remove processor", style: .destructive))
                    })
                }
            }
            if permissions.allows(MediaPermissions.VariantProcessors.create) {
                context.build(MediaVariantProcessorFormView(
                    processor: nil,
                    action: MediaVariantRoutes.processorAdd(RouterPath(id)).description,
                    nonceToken: addProcessorNonce
                ))
            }
        }
        .class("cms-section")
    }
}

struct MediaVariantProcessorFormTokens: Sendable {
    let edit: String
    let remove: String
}

struct MediaVariantProcessorFormView: Component {
    let processor: MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema?
    let action: String
    let nonceToken: String

    func html(context: inout BuilderContext) -> Form {
        let isNew = processor == nil
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            H3(isNew ? "Add processor" : "Edit \(processor?.name ?? "")")
            context.build(NewAdminFormFieldInput(state: .init(name: "name", label: "Processor", value: processor?.name ?? "", isRequired: true)))
            context.build(NewAdminFormFieldInput(state: .init(name: "matchExtensions", label: "Input extensions", value: processor?.matchExtensions ?? "", isRequired: true)))
            context.build(NewAdminFormFieldTextArea(state: .init(name: "commandTemplate", label: "Command template", value: processor?.commandTemplate ?? "", style: .small, isRequired: true)))
            context.build(NewAdminFormFieldCheckbox(state: .init(name: "isActive", label: "Status", checkboxLabel: "Active processor", isChecked: processor?.isActive ?? true)))
            context.build(NewAdminSubmitButton(isNew ? "Add processor" : "Save processor", style: .primary))
        }
        return context.build(form)
    }
}
