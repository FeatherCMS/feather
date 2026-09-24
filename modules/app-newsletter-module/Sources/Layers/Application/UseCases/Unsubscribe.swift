public import FeatherApplication
public import FeatherContracts
import NewsletterDomain

import struct Foundation.Date

public struct Unsubscribe: UseCase {
    struct Error: UseCaseError {
        let message: String
    }

    let transaction: any TransactionExecutor<Write>

    public init(
        transaction: any TransactionExecutor<Write>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let campaignKey: String
        public let email: String

        public init(
            campaignKey: String,
            email: String
        ) {
            self.campaignKey = campaignKey
            self.email = email
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
            else {
                throw Error(message: "Newsletter campaign not found")
            }
            guard
                var model = try await scope.subscriber.findBy(
                    newsletterId: campaign.id,
                    email: input.email
                )
            else {
                throw Error(message: "Newsletter subscriber not found")
            }

            model.unsubscribe(at: now)
            return (try await scope.subscriber.update(model)).asDetail
        }
    }
}
