import Application
import ContactDomain

public struct ListContactForms: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public init() {} }
    public func execute(_ input: Input) async throws -> [ContactFormDetail] {
        try await transaction.run { context in try await context.form.list().map(\.asDetail) }
    }
}
