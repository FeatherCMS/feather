import ContactAdminAPI
import ContactApplication
import ContactDomain
import Foundation

extension ContactBackend {
    private func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }

    public func map(
        _ value: FormDetail
    ) -> Components.Schemas.ContactFormSchema {
        .init(
            id: value.id,
            name: value.name,
            successMessage: value.successMessage,
            failureMessage: value.failureMessage,
            redirectUrl: value.redirectUrl,
            items: value.fields.map(map),
            mails: value.mails.map(map),
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    public func map(
        _ value: FormFieldDetail
    ) -> Components.Schemas.FormFieldSchema {
        .init(
            id: value.id,
            formId: value.formId,
            key: value.key,
            _type: value.type.rawValue,
            label: value.label,
            allowedValues: value.allowedValues.map(\.value),
            isRequired: value.isRequired,
            position: value.position,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    public func map(
        _ value: SubmissionMailDetail
    ) -> Components.Schemas.SubmissionMailSchema {
        .init(
            id: value.id,
            formId: value.formId,
            mailFrom: value.mailFrom,
            mailTo: value.mailTo,
            subject: value.subject,
            additionalHeaders: value.additionalHeaders,
            messageBody: value.messageBody,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    public func map(
        _ value: SubmissionDetail
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        .init(
            id: value.id,
            formId: value.formId,
            values: .init(
                additionalProperties: jsonProperties(value.valuesJSON)
            ),
            itemsSnapshot: .init(
                additionalProperties: jsonProperties(value.itemsSnapshotJSON)
            ),
            metadata: .init(
                additionalProperties: jsonProperties(value.metadataJSON ?? "{}")
            ),
            status: value.status.rawValue,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    private func jsonProperties(_ value: String) -> [String: String] {
        guard let data = value.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            let dictionary = object as? [String: Any]
        else { return [:] }
        return dictionary.mapValues { String(describing: $0) }
    }
}
