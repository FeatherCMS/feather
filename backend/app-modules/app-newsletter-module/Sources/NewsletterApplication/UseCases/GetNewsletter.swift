import Application
import NewsletterDomain

public struct GetNewsletter: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public init(id: String) { self.id = id }
    }
    public func execute(_ input: Input) async throws -> NewsletterDetail {
        try await transaction.run { context in
            guard let value = try await context.newsletter.findBy(id: input.id)
            else { throw Error.notFound }
            return value.asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
