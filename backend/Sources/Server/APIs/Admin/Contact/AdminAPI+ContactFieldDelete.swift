import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFieldDelete(
        _ input: Operations.ContactFieldDelete.Input
    ) async throws -> Operations.ContactFieldDelete.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.delete
        )
        try await modules.contact.makeDeleteContactFormItem()
            .execute(.init(id: input.path.contactFormItemId, formId: nil))
        return .noContent
    }
}
