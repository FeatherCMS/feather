import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormUpdate(_ input: Operations.ContactFormUpdate.Input) async throws -> Operations.ContactFormUpdate.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Forms.update)
        let body: Components.Schemas.ContactFormCreateSchema
        switch input.body { case let .json(value): body = value }
        let result = try await modules.contact.makeUpdateContactForm().execute(.init(id: input.path.contactFormId, name: body.name))
        return .ok(.init(body: .json(map(result))))
    }
}
