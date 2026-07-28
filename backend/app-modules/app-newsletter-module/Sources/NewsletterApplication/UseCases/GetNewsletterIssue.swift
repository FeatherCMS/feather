import Application
import NewsletterDomain

public struct GetNewsletterIssue: UseCase {
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
    ) async throws -> NewsletterIssueDetail {
        try await transaction.run { context in
            guard let issue = try await context.issue.findBy(id: input.id)
            else {
                throw Error.notFound
            }
            return issue.asDetail
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
