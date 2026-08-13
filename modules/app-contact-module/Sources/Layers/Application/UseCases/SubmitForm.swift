import ContactDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation

import struct Foundation.Date

public struct SubmitForm: UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let transaction: any TransactionExecutor<WriteForm>

    public init(
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let formId: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?

        public init(
            formId: String,
            valuesJSON: String,
            itemsSnapshotJSON: String,
            metadataJSON: String? = nil
        ) {
            self.formId = formId
            self.valuesJSON = valuesJSON
            self.itemsSnapshotJSON = itemsSnapshotJSON
            self.metadataJSON = metadataJSON
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> SubmissionDetail {
        try await transaction.run { scope in
            let fields = try await scope.field.listBy(formId: input.formId)
            try validate(
                valuesJSON: input.valuesJSON,
                against: fields
            )

            let model = Submission.create(
                formId: input.formId,
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
            throw Error(message: "Form values must be a JSON object")
        }

        for field in fields {
            guard let value = values[field.key] else {
                if field.isRequired {
                    throw Error(
                        message: "Missing required form field: (field.key)"
                    )
                }
                continue
            }

            switch field.type {
            case .text, .textarea:
                guard value is String else {
                    throw Error(
                        message: "Invalid value for form field: (field.key)"
                    )
                }
            case .select, .radio:
                guard
                    let stringValue = value as? String,
                    field.allowedValues.contains(where: {
                        $0.value == stringValue
                    })
                else {
                    throw Error(
                        message: "Invalid option for form field: (field.key)"
                    )
                }
            case .toggle:
                guard value is Bool else {
                    throw Error(
                        message: "Invalid value for form field: (field.key)"
                    )
                }
            }
        }
    }
}
