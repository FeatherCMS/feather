import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormItemDelete(_ input: Operations.ContactFormItemDelete.Input) async throws -> Operations.ContactFormItemDelete.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Items.delete)
        try await modules.contact.makeDeleteContactFormItem().execute(.init(id: input.path.contactFormItemId))
        return .noContent
    }
}
