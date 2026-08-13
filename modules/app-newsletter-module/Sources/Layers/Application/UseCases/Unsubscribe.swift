import FeatherApplication
import FeatherContracts
import FeatherDomain
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
        public let newsletterId: String
        public let email: String

        public init(
            newsletterId: String,
            email: String
        ) {
            self.newsletterId = newsletterId
            self.email = email
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> SubscriberDetail {
        let now = Date()
        return try await transaction.run { scope in
            guard
                var model = try await scope.subscriber.findBy(
                    newsletterId: input.newsletterId,
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
