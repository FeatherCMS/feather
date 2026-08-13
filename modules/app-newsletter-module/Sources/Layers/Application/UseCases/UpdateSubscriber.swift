import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsletterDomain

import struct Foundation.Date

public struct UpdateSubscriber: UseCase {
    struct Error: UseCaseError { let message: String }
    struct Action: PermissionAction { let key = Permissions.Subscribers.update }
    let transaction: any TransactionExecutor<Write>
    let authorizer: any Authorizer

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
            firstName: String,
            lastName: String,
            status: Subscriber.Status
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
            guard
                var model = try await scope.subscriber.findBy(
                    newsletterId: input.newsletterId,
                    email: input.email
                )
            else { throw Error(message: "Newsletter subscriber not found") }
            model.firstName = input.firstName
            model.lastName = input.lastName
            if input.status == .subscribed && model.status != .subscribed {
                model.subscribe(at: now)
            }
            if input.status == .unsubscribed && model.status != .unsubscribed {
                model.unsubscribe(at: now)
            }
            return try await scope.subscriber.update(model).asDetail
        }
    }
}
