import Application
import ContactDomain

public struct DeleteContactFormItem: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }
    public func execute(_ input: Input) async throws {
        try await transaction.run { context in
            guard try await context.item.delete(id: input.id) else { throw Error(message: "Contact form item not found") }
        }
    }
}
