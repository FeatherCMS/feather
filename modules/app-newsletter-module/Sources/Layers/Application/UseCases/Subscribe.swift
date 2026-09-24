public import FeatherApplication
public import FeatherContracts
import NewsletterDomain

import struct Foundation.Date

public struct Subscribe: UseCase {
    let transaction: any TransactionExecutor<Write>

    public init(
        transaction: any TransactionExecutor<Write>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let campaignKey: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let unsubscribeToken: String?
        public let source: String?

        public init(
            campaignKey: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            unsubscribeToken: String? = nil,
            source: String? = nil
        ) {
            self.campaignKey = campaignKey
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.unsubscribeToken = unsubscribeToken
            self.source = source
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> SubscriberDetail {
        let now = Date()
        return try await transaction.run { scope in
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { throw Error.campaignNotFound }
            if var model = try await scope.subscriber.findBy(
                newsletterId: campaign.id,
                email: input.email
            ) {
                model.subscribe(at: now)
                model.firstName = input.firstName
                model.lastName = input.lastName
                return (try await scope.subscriber.update(model)).asDetail
            }

            let newModel = try Subscriber.create(
                newsletterId: campaign.id,
                email: input.email,
                subscriptionDate: now,
                firstName: input.firstName,
                lastName: input.lastName,
                unsubscribeToken: input.unsubscribeToken,
                source: input.source
            )
            return (try await scope.subscriber.insert(newModel)).asDetail
        }
    }

    public enum Error: UseCaseError { case campaignNotFound }
}
