import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFieldGet(
        _ input: Operations.ContactFieldGet.Input
    ) async throws -> Operations.ContactFieldGet.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.read
        )
        let result = try await modules.contact.makeGetContactFormItem()
            .execute(.init(id: input.path.contactFormItemId, formId: nil))
        return .ok(.init(body: .json(map(result))))
    }
}
