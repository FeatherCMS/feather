import Application
import NewsletterDomain

public struct ListNewsletterSubscribers: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let newsletterId: String
        public init(newsletterId: String) { self.newsletterId = newsletterId }
    }

    public func execute(_ input: Input) async throws -> [NewsletterSubscriberDetail] {
        try await transaction.run { context in
            try await context.subscriber.list(newsletterId: input.newsletterId).map(\.asDetail)
        }
    }
}
