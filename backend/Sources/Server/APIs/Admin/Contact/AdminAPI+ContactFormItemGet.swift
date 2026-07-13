import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormItemGet(_ input: Operations.ContactFormItemGet.Input) async throws -> Operations.ContactFormItemGet.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Items.read)
        let result = try await modules.contact.makeGetContactFormItem().execute(.init(id: input.path.contactFormItemId))
        return .ok(.init(body: .json(map(result))))
    }
}
