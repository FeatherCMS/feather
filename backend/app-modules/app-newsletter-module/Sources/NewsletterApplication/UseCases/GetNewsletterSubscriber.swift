import Application
import NewsletterDomain

public struct GetNewsletterSubscriber: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let newsletterId: String
        public let email: String
        public init(newsletterId: String, email: String) {
            self.newsletterId = newsletterId
            self.email = email
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterSubscriberDetail {
        try await transaction.run { context in
            guard
                let value = try await context.subscriber.findBy(
                    newsletterId: input.newsletterId,
                    email: input.email
                )
            else { throw Error(message: "Newsletter subscriber not found") }
            return value.asDetail
        }
    }
}
