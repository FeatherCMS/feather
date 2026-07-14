import AdminOpenAPI
import ContactApplication
import ContactDomain
import Foundation

extension AdminAPI {
    func map(
        _ value: ContactFormDetail
    ) -> Components.Schemas.ContactFormSchema {
        .init(id: value.id, name: value.name, successMessage: value.successMessage, failureMessage: value.failureMessage, redirectUrl: value.redirectUrl, items: value.items.map(map), mails: value.mails.map(map), createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    func map(
        _ value: ContactFormItemDetail
    ) -> Components.Schemas.ContactFormItemSchema {
        .init(id: value.id, formId: value.formId, key: value.key, _type: value.type.rawValue, label: value.label, allowedValues: value.allowedValues.map(\.value), isRequired: value.isRequired, position: value.position, createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    func map(
        _ value: ContactFormMailDetail
    ) -> Components.Schemas.ContactFormMailSchema {
        .init(id: value.id, formId: value.formId, mailFrom: value.mailFrom, mailTo: value.mailTo, subject: value.subject, additionalHeaders: value.additionalHeaders, messageBody: value.messageBody, createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    func map(
        _ value: ContactFormSubmissionDetail
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        .init(id: value.id, formId: value.formId, values: .init(additionalProperties: jsonProperties(value.valuesJSON)), itemsSnapshot: .init(additionalProperties: jsonProperties(value.itemsSnapshotJSON)), metadata: .init(additionalProperties: jsonProperties(value.metadataJSON ?? "{}")), status: value.status.rawValue, createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    private func jsonProperties(_ value: String) -> [String: String] {
        guard let data = value.data(using: .utf8), let object = try? JSONSerialization.jsonObject(with: data), let dictionary = object as? [String: Any] else { return [:] }
        return dictionary.mapValues { String(describing: $0) }
    }
}
