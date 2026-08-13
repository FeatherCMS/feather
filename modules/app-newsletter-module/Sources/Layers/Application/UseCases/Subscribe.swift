import FeatherApplication
import FeatherContracts
import FeatherDomain
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
    ) async throws -> SubscriberDetail {
        let now = Date()
        return try await transaction.run { scope in
            if var model = try await scope.subscriber.findBy(
                newsletterId: input.newsletterId,
                email: input.email
            ) {
                model.subscribe(at: now)
                model.firstName = input.firstName
                model.lastName = input.lastName
                return (try await scope.subscriber.update(model)).asDetail
            }

            let newModel = try Subscriber.create(
                newsletterId: input.newsletterId,
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
}
