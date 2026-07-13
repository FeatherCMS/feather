import Application
import ContactDomain

public struct UpdateContactFormItem: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO {
        public let id: String
        public let key: String?
        public let type: ContactFormItem.ItemType?
        public let label: String?
        public let allowedValues: [ContactFormItem.Option]?
        public let isRequired: Bool?
        public let position: Int?
        public init(id: String, key: String? = nil, type: ContactFormItem.ItemType? = nil, label: String? = nil, allowedValues: [ContactFormItem.Option]? = nil, isRequired: Bool? = nil, position: Int? = nil) { self.id = id; self.key = key; self.type = type; self.label = label; self.allowedValues = allowedValues; self.isRequired = isRequired; self.position = position }
    }
    public func execute(_ input: Input) async throws -> ContactFormItemDetail {
        try await transaction.run { context in
            guard var value = try await context.item.findBy(id: input.id) else { throw Error(message: "Contact form item not found") }
            try value.update(key: input.key, type: input.type, label: input.label, allowedValues: input.allowedValues, isRequired: input.isRequired, position: input.position)
            return try await context.item.update(value).asDetail
        }
    }
}
