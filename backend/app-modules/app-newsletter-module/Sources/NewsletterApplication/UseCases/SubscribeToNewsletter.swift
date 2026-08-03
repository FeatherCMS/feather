import Application
import NewsletterDomain
import struct Foundation.Date

public struct SubscribeToNewsletter: UseCase {
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
        public let unsubscribeToken: String?
        public let source: String?

        public init(
            newsletterId: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            unsubscribeToken: String? = nil,
            source: String? = nil
        ) {
            self.newsletterId = newsletterId
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.unsubscribeToken = unsubscribeToken
            self.source = source
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterSubscriberDetail {
        let now = Date(timeIntervalSince1970: clock.now())
        return try await transaction.run { context in
            if var model = try await context.subscriber.findBy(
                newsletterId: input.newsletterId,
                email: input.email
            ) {
                model.subscribe(at: now)
                model.firstName = input.firstName
                model.lastName = input.lastName
                return (try await context.subscriber.update(model)).asDetail
            }

            let newModel = try NewsletterCampaignSubscriber.create(
                newsletterId: input.newsletterId,
                email: input.email,
                subscriptionDate: now,
                firstName: input.firstName,
                lastName: input.lastName,
                unsubscribeToken: input.unsubscribeToken,
                source: input.source
            )
            return (try await context.subscriber.insert(newModel)).asDetail
        }
    }
}
