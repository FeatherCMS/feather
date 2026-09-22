import ContactDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation

import struct Foundation.Date

public struct SubmitForm: UseCase {
    let transaction: any TransactionExecutor<WriteForm>

    public init(
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let formKey: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?

        public init(
            formKey: String,
            valuesJSON: String,
            itemsSnapshotJSON: String,
            metadataJSON: String? = nil
        ) {
            self.formKey = formKey
            self.valuesJSON = valuesJSON
            self.itemsSnapshotJSON = itemsSnapshotJSON
            self.metadataJSON = metadataJSON
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> SubmissionDetail {
        try await transaction.run { scope in
            guard let form = try await scope.form.findBy(key: input.formKey)
            else {
                throw Error.formNotFound
            }
            let fields = try await scope.field.listBy(formId: form.id)
            try validate(
                valuesJSON: input.valuesJSON,
                against: fields
            )

            let model = Submission.create(
                formId: form.id,
                valuesJSON: input.valuesJSON,
                itemsSnapshotJSON: input.itemsSnapshotJSON,
                metadataJSON: input.metadataJSON,
            )
            return (try await scope.submission.insert(model)).asDetail
        }
    }

    private func validate(
        valuesJSON: String,
        against fields: [FormField]
    ) throws {
        guard
            let data = valuesJSON.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            let values = object as? [String: Any]
        else {
            throw Error.invalidValues("Form values must be a JSON object")
        }

        for field in fields {
            guard let value = values[field.key] else {
                if field.isRequired {
                    throw Error.invalidValues(
                        "Missing required form field: \(field.key)"
                    )
                }
                continue
            }

            switch field.type {
            case .text, .textarea:
                guard value is String else {
                    throw Error.invalidValues(
                        "Invalid value for form field: \(field.key)"
                    )
                }
            case .select, .radio:
                guard
                    let stringValue = value as? String,
                    field.allowedValues.contains(where: {
                        $0.value == stringValue
                    })
                else {
                    throw Error.invalidValues(
                        "Invalid option for form field: \(field.key)"
                    )
                }
            case .toggle:
                guard
                    let stringValue = value as? String,
                    ["true", "false"].contains(stringValue)
                else {
                    throw Error.invalidValues(
                        "Invalid value for form field: \(field.key)"
                    )
                }
            }
        }
    }

    public enum Error: UseCaseError {
        case formNotFound
        case invalidValues(String)
    }
}
