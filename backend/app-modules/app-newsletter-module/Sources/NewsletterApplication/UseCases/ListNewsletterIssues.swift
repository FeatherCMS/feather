import Application
import NewsletterDomain

public struct ListNewsletterIssues: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let newsletterId: String

        public init(newsletterId: String) {
            self.newsletterId = newsletterId
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> [NewsletterIssueDetail] {
        try await transaction.run { context in
            try await context.issue.list(newsletterId: input.newsletterId)
                .map(\.asDetail)
        }
    }
}
