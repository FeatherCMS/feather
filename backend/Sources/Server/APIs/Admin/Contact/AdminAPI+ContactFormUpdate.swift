import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormUpdate(_ input: Operations.ContactFormUpdate.Input) async throws -> Operations.ContactFormUpdate.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Forms.update)
        let body: Components.Schemas.ContactFormCreateSchema
        switch input.body { case let .json(value): body = value }
        let result = try await modules.contact.makeUpdateContactForm().execute(.init(id: input.path.contactFormId, name: body.name, successMessage: body.successMessage ?? "", failureMessage: body.failureMessage ?? "", redirectUrl: body.redirectUrl, fieldIds: body.fieldIds ?? [], mails: (body.mails ?? []).map { .init(mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders ?? "", messageBody: $0.messageBody) }))
        return .ok(.init(body: .json(map(result))))
    }
}
