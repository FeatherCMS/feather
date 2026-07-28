import Application
import ContactDomain

public struct GetContactFormItem: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) {
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public let formId: String?
        public init(id: String, formId: String?) {
            self.id = id
            self.formId = formId
        }
    }
    public func execute(_ input: Input) async throws -> ContactFormItemDetail {
        try await transaction.run { context in
            guard
                let value = try await context.item.findBy(
                    id: input.id,
                    formId: input.formId
                )
            else {
                throw Error(message: "Contact form item not found")
            }
            return value.asDetail
        }
    }
}
