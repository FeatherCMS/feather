import Application
import NewsletterDomain

public struct UpdateNewsletter: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    public init(transaction: any TransactionExecutor<WriteNewsletter>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public let name: String; public init(id: String, name: String) { self.id = id; self.name = name } }
    public func execute(_ input: Input) async throws -> NewsletterDetail {
        try await transaction.run { context in
            guard var value = try await context.newsletter.findBy(id: input.id) else { throw Error.notFound }
            try value.update(name: input.name)
            return (try await context.newsletter.update(value)).asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
