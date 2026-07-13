import Application
import ContactDomain

public struct UpdateContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public let name: String; public init(id: String, name: String) { self.id = id; self.name = name } }
    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            guard var value = try await context.form.findBy(id: input.id) else { throw Error.notFound }
            try value.update(name: input.name)
            return (try await context.form.update(value)).asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
