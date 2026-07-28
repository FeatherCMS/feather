import Application
import ContactDomain

public struct CreateContactFormItem: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    let idGenerator: any IDGenerator

    public init(
        transaction: any TransactionExecutor<WriteContactForm>,
        idGenerator: any IDGenerator
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let formId: String?
        public let key: String
        public let type: ContactFormItem.ItemType
        public let label: String
        public let allowedValues: [ContactFormItem.Option]
        public let isRequired: Bool
        public let position: Int

        public init(
            formId: String?,
            key: String,
            type: ContactFormItem.ItemType,
            label: String,
            allowedValues: [ContactFormItem.Option] = [],
            isRequired: Bool = false,
            position: Int = 0
        ) {
            self.formId = formId
            self.key = key
            self.type = type
            self.label = label
            self.allowedValues = allowedValues
            self.isRequired = isRequired
            self.position = position
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> ContactFormItemDetail {
        try await transaction.run { context in
            let model = try ContactFormItem.create(
                id: idGenerator.generate(),
                formId: input.formId ?? "",
                key: input.key,
                type: input.type,
                label: input.label,
                allowedValues: input.allowedValues,
                isRequired: input.isRequired,
                position: input.position
            )
            let item = try await context.item.insert(model)
            if let formId = input.formId {
                try await context.item.assign(
                    formId: formId,
                    itemId: item.id,
                    position: input.position
                )
            }
            return item.asDetail
        }
    }
}
