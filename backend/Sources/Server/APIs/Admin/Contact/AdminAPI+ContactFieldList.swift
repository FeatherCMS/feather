import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFieldList(
        _ input: Operations.ContactFieldList.Input
    ) async throws -> Operations.ContactFieldList.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.list
        )
        let result = try await modules.contact.makeListContactFormItems()
            .execute(.init(formId: nil))
        return .ok(.init(body: .json(result.map(map))))
    }
}
