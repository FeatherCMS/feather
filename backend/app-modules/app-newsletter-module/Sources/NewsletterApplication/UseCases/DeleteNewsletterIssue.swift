import Application
import NewsletterDomain

public struct DeleteNewsletterIssue: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        _ input: Input
    ) async throws {
        try await transaction.run { context in
            guard try await context.issue.delete(id: input.id) else {
                throw Error.notFound
            }
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
