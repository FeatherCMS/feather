import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormDelete(_ input: Operations.ContactFormDelete.Input) async throws -> Operations.ContactFormDelete.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Forms.delete)
        _ = try await modules.contact.makeDeleteContactForm().execute(.init(id: input.path.contactFormId))
        return .noContent
    }
}
