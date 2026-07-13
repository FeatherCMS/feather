import Application
import ContactDomain

public struct DeleteContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }
    public func execute(_ input: Input) async throws -> Bool { try await transaction.run { context in try await context.form.delete(id: input.id) } }
}
