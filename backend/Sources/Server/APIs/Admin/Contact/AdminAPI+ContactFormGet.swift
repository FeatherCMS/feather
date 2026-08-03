import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormGet(
        _ input: Operations.ContactFormGet.Input
    ) async throws -> Operations.ContactFormGet.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Forms.read
        )
        let result = try await modules.contact.makeGetContactForm()
            .execute(.init(id: input.path.contactFormId))
        return .ok(.init(body: .json(map(result))))
    }
}
