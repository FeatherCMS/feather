import Application
import ContactDomain
import Foundation
import struct Foundation.Date

public struct SubmitContactForm: UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let transaction: any TransactionExecutor<WriteContactForm>
    let idGenerator: any IDGenerator
    let clock: any Clock

    public init(
        transaction: any TransactionExecutor<WriteContactForm>,
        idGenerator: any IDGenerator,
        clock: any Clock
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.clock = clock
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
    ) async throws -> ContactFormSubmissionDetail {
        let now = Date(timeIntervalSince1970: clock.now())
        return try await transaction.run { context in
            let items = try await context.item.listBy(formId: input.formId)
            try validate(
                valuesJSON: input.valuesJSON,
                against: items
            )

            let model = ContactFormSubmission.create(
                id: idGenerator.generate(),
                formId: input.formId,
                valuesJSON: input.valuesJSON,
                itemsSnapshotJSON: input.itemsSnapshotJSON,
                metadataJSON: input.metadataJSON,
                submittedAt: now
            )
            return (try await context.submission.insert(model)).asDetail
        }
    }

    private func validate(
        valuesJSON: String,
        against items: [ContactFormItem]
    ) throws {
        guard
            let data = valuesJSON.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            let values = object as? [String: Any]
        else {
            throw Error(message: "Form values must be a JSON object")
        }

        for item in items {
            guard let value = values[item.key] else {
                if item.isRequired {
                    throw Error(message: "Missing required form item: (item.key)")
                }
                continue
            }

            switch item.type {
            case .text, .textarea:
                guard value is String else {
                    throw Error(message: "Invalid value for form item: (item.key)")
                }
            case .select, .radio:
                guard
                    let stringValue = value as? String,
                    item.allowedValues.contains(where: { $0.value == stringValue })
                else {
                    throw Error(message: "Invalid option for form item: (item.key)")
                }
            case .toggle:
                guard value is Bool else {
                    throw Error(message: "Invalid value for form item: (item.key)")
                }
            }
        }
    }
}
