import Application
import NewsletterDomain

public struct ListNewsletterDeliveries: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let issueId: String

        public init(issueId: String) {
            self.issueId = issueId
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> [NewsletterDeliveryDetail] {
        try await transaction.run { context in
            try await context.delivery.list(issueId: input.issueId).map(NewsletterDeliveryDetail.init)
        }
    }
}
