import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsletterDomain

import struct Foundation.Date

public struct CreateSubscriber: UseCase {
    struct Action: PermissionAction { let key = Permissions.Subscribers.create }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let newsletterId: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let status: Subscriber.Status
        public init(
            newsletterId: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            status: Subscriber.Status = .subscribed
        ) {
            self.newsletterId = newsletterId
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.status = status
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SubscriberDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let now = Date()
        return try await transaction.run { scope in
            let value = try Subscriber.create(
                newsletterId: input.newsletterId,
                email: input.email,
                subscriptionDate: now,
                firstName: input.firstName,
                lastName: input.lastName
            )
            if input.status == .unsubscribed {
                var model = try await scope.subscriber.insert(value)
                model.unsubscribe(at: now)
                return try await scope.subscriber.update(model).asDetail
            }
            return try await scope.subscriber.insert(value).asDetail
        }
    }
}
