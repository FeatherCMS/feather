import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFormCreate(
        _ input: Operations.ContactFormCreate.Input
    ) async throws -> Operations.ContactFormCreate.Output {
        let body: Components.Schemas.ContactFormCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await self.makeCreateContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
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
        return .created(.init(body: .json(map(result))))
    }
}
