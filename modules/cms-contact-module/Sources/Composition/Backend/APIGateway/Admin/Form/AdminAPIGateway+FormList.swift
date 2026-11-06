public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFormList(
        _ input: Operations.ContactFormList.Input
    ) async throws -> Operations.ContactFormList.Output {
        let result = try await self.useCases.makeListForms()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init()
            )
        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        mapForm(
                            key: $0.key,
                            name: $0.name,
                            successMessage: $0.successMessage,
                            failureMessage: $0.failureMessage,
                            submitLabel: $0.submitLabel,
                            redirectUrl: $0.redirectUrl,
                            fields: $0.fields,
                            mails: $0.mails,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt
                        )
                    }
                )
            )
        )
    }

    private func mapForm(
        key: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        submitLabel: String,
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
            submitLabel: submitLabel,
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
