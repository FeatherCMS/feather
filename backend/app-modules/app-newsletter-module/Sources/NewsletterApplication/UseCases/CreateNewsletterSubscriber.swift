import Application
import NewsletterDomain
import struct Foundation.Date

public struct CreateNewsletterSubscriber: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    let clock: any Clock

    public init(
        transaction: any TransactionExecutor<WriteNewsletter>,
        clock: any Clock
    ) {
        self.transaction = transaction
        self.clock = clock
    }

    public struct Input: DTO {
        public let newsletterId: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let status: NewsletterCampaignSubscriber.Status
        public init(
            newsletterId: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            status: NewsletterCampaignSubscriber.Status = .subscribed
        ) {
            self.newsletterId = newsletterId
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.status = status
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterSubscriberDetail {
        let now = Date(timeIntervalSince1970: clock.now())
        return try await transaction.run { context in
            let value = try NewsletterCampaignSubscriber.create(
                newsletterId: input.newsletterId,
                email: input.email,
                subscriptionDate: now,
                firstName: input.firstName,
                lastName: input.lastName
            )
            if input.status == .unsubscribed {
                var model = try await context.subscriber.insert(value)
                model.unsubscribe(at: now)
                return try await context.subscriber.update(model).asDetail
            }
            return try await context.subscriber.insert(value).asDetail
        }
    }
}
