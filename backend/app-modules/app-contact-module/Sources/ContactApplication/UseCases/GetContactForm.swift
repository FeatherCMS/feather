import Application
import ContactDomain

public struct GetContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }
    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            guard let value = try await context.form.findBy(id: input.id) else { throw Error.notFound }
            return value.asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
