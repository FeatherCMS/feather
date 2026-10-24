public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFormCreate(
        _ input: Operations.ContactFormCreate.Input
    ) async throws -> Operations.ContactFormCreate.Output {
        let body: Components.Schemas.ContactFormCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await self.useCases.makeCreateContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        key: body.key,
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
                                        ?? [],
                                    messageBody: $0.messageBody
                                )
                            }
                    )
            )
        return .created(
            .init(
                body: .json(
                    mapForm(
                        key: result.key,
                        name: result.name,
                        successMessage: result.successMessage,
                        failureMessage: result.failureMessage,
                        redirectUrl: result.redirectUrl,
                        fields: result.fields,
                        mails: result.mails,
                        createdAt: result.createdAt,
                        updatedAt: result.updatedAt
                    )
                )
            )
        )
    }

    private func mapForm(
        key: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fields: [Form.Field],
        mails: [Form.Mail],
        createdAt: Date,
        updatedAt: Date
    ) -> Components.Schemas.ContactFormSchema {
        .init(
            key: key,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            items: fields.map {
                .init(
                    id: $0.id,
                    key: $0.key,
                    _type: $0.type.rawValue,
                    label: $0.label,
                    allowedValues: $0.allowedValues.map(\.value),
                    isRequired: $0.isRequired,
                    position: $0.position,
                    createdAt: $0.createdAt.timeIntervalSince1970,
                    updatedAt: $0.updatedAt.timeIntervalSince1970
                )
            },
            mails: mails.map {
                .init(
                    id: $0.id,
                    mailFrom: $0.mailFrom,
                    mailTo: $0.mailTo,
                    subject: $0.subject,
                    additionalHeaders: $0.additionalHeaders,
                    messageBody: $0.messageBody,
                    createdAt: $0.createdAt.timeIntervalSince1970,
                    updatedAt: $0.updatedAt.timeIntervalSince1970
                )
            },
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
        )
    }
}
