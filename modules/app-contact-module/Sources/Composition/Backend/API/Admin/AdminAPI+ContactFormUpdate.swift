import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFormUpdate(
        _ input: Operations.ContactFormUpdate.Input
    ) async throws -> Operations.ContactFormUpdate.Output {
        let body: Components.Schemas.ContactFormCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await self.makeUpdateContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.contactFormId,
                        name: body.name,
                        successMessage: body.successMessage ?? "",
                        failureMessage: body.failureMessage ?? "",
                        redirectUrl: body.redirectUrl,
                        fieldIds: body.fieldIds ?? [],
                        mails: (body.mails ?? [])
                            .map {
                                .init(
                                    mailFrom: $0.mailFrom,
                                    mailTo: $0.mailTo,
                                    subject: $0.subject,
                                    additionalHeaders: $0.additionalHeaders
                                        ?? "",
                                    messageBody: $0.messageBody
                                )
                            }
                    )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
