import Application
import NewsletterDomain
import struct Foundation.Date

public struct UpdateNewsletterSubscriber: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteNewsletter>
    let clock: any Clock

    public init(transaction: any TransactionExecutor<WriteNewsletter>, clock: any Clock) { self.transaction = transaction; self.clock = clock }

    public struct Input: DTO {
        public let newsletterId: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let status: NewsletterCampaignSubscriber.Status
        public init(newsletterId: String, email: String, firstName: String, lastName: String, status: NewsletterCampaignSubscriber.Status) { self.newsletterId = newsletterId; self.email = email; self.firstName = firstName; self.lastName = lastName; self.status = status }
    }

    public func execute(_ input: Input) async throws -> NewsletterSubscriberDetail {
        let now = Date(timeIntervalSince1970: clock.now())
        return try await transaction.run { context in
            guard var model = try await context.subscriber.findBy(newsletterId: input.newsletterId, email: input.email) else { throw Error(message: "Newsletter subscriber not found") }
            model.firstName = input.firstName
            model.lastName = input.lastName
            if input.status == .subscribed && model.status != .subscribed { model.subscribe(at: now) }
            if input.status == .unsubscribed && model.status != .unsubscribed { model.unsubscribe(at: now) }
            return try await context.subscriber.update(model).asDetail
        }
    }
}
