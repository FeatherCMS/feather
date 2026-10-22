public import ContactAdminAPI
public import ContactApplication
import ContactDomain
public import ContactModule
import Foundation

extension AdminAPIGateway {
    private func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }

    public func map(
        _ value: Form.Detail.Output
    ) -> Components.Schemas.ContactFormSchema {
        mapForm(
            key: value.key,
            name: value.name,
            successMessage: value.successMessage,
            failureMessage: value.failureMessage,
            redirectUrl: value.redirectUrl,
            fields: value.fields,
            mails: value.mails,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: Form.Add.Output
    ) -> Components.Schemas.ContactFormSchema {
        mapForm(
            key: value.key,
            name: value.name,
            successMessage: value.successMessage,
            failureMessage: value.failureMessage,
            redirectUrl: value.redirectUrl,
            fields: value.fields,
            mails: value.mails,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: Form.Edit.Output
    ) -> Components.Schemas.ContactFormSchema {
        mapForm(
            key: value.key,
            name: value.name,
            successMessage: value.successMessage,
            failureMessage: value.failureMessage,
            redirectUrl: value.redirectUrl,
            fields: value.fields,
            mails: value.mails,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: Form.List.Output.Item
    ) -> Components.Schemas.ContactFormSchema {
        mapForm(
            key: value.key,
            name: value.name,
            successMessage: value.successMessage,
            failureMessage: value.failureMessage,
            redirectUrl: value.redirectUrl,
            fields: value.fields,
            mails: value.mails,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
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
            items: fields.map(map),
            mails: mails.map(map),
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
        )
    }

    public func map(
        _ value: FormField.Detail.Output
    ) -> Components.Schemas.FormFieldSchema {
        mapFormField(
            id: value.id,
            key: value.key,
            type: value.type,
            label: value.label,
            allowedValues: value.allowedValues,
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    private func map(
        _ value: Form.Field
    ) -> Components.Schemas.FormFieldSchema {
        mapFormField(
            id: value.id,
            key: value.key,
            type: value.type,
            label: value.label,
            allowedValues: value.allowedValues,
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: FormField.Add.Output
    ) -> Components.Schemas.FormFieldSchema {
        mapFormField(
            id: value.id,
            key: value.key,
            type: value.type,
            label: value.label,
            allowedValues: value.allowedValues,
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: FormField.Edit.Output
    ) -> Components.Schemas.FormFieldSchema {
        mapFormField(
            id: value.id,
            key: value.key,
            type: value.type,
            label: value.label,
            allowedValues: value.allowedValues,
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    public func map(
        _ value: FormField.List.Output.Item
    ) -> Components.Schemas.FormFieldSchema {
        mapFormField(
            id: value.id,
            key: value.key,
            type: value.type,
            label: value.label,
            allowedValues: value.allowedValues,
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    private func mapFormField(
        id: String,
        key: String,
        type: FormField.Model.ItemType,
        label: String,
        allowedValues: [FormField.Model.Option],
        isRequired: Bool,
        position: Int,
        createdAt: Date,
        updatedAt: Date
    ) -> Components.Schemas.FormFieldSchema {
        .init(
            id: id,
            key: key,
            _type: type.rawValue,
            label: label,
            allowedValues: allowedValues.map(\.value),
            isRequired: isRequired,
            position: position,
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
        )
    }

    public func map(
        _ value: SubmissionMail.Detail.Output
    ) -> Components.Schemas.SubmissionMailSchema {
        .init(
            id: value.id,
            mailFrom: value.mailFrom,
            mailTo: value.mailTo,
            subject: value.subject,
            additionalHeaders: value.additionalHeaders,
            messageBody: value.messageBody,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    private func map(
        _ value: Form.Mail
    ) -> Components.Schemas.SubmissionMailSchema {
        .init(
            id: value.id,
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
        _ value: Submission.Detail.Output,
        formKey: String
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        mapSubmission(
            id: value.id,
            valuesJSON: value.valuesJSON,
            itemsSnapshotJSON: value.itemsSnapshotJSON,
            metadataJSON: value.metadataJSON,
            status: value.status,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            formKey: formKey
        )
    }

    public func map(
        _ value: Submission.Edit.Output,
        formKey: String
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        mapSubmission(
            id: value.id,
            valuesJSON: value.valuesJSON,
            itemsSnapshotJSON: value.itemsSnapshotJSON,
            metadataJSON: value.metadataJSON,
            status: value.status,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            formKey: formKey
        )
    }

    public func map(
        _ value: Submission.List.Output.Item,
        formKey: String
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        mapSubmission(
            id: value.id,
            valuesJSON: value.valuesJSON,
            itemsSnapshotJSON: value.itemsSnapshotJSON,
            metadataJSON: value.metadataJSON,
            status: value.status,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            formKey: formKey
        )
    }

    private func mapSubmission(
        id: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String?,
        status: Submission.Model.Status,
        createdAt: Date,
        updatedAt: Date,
        formKey: String
    ) -> Components.Schemas.ContactFormSubmissionSchema {
        .init(
            id: id,
            formKey: formKey,
            values: .init(
                additionalProperties: jsonProperties(valuesJSON)
            ),
            itemsSnapshot: .init(
                additionalProperties: jsonProperties(itemsSnapshotJSON)
            ),
            metadata: .init(
                additionalProperties: jsonProperties(metadataJSON ?? "{}")
            ),
            status: status.rawValue,
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
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
