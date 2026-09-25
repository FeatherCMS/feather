public import FeatherApplication
public import FeatherContracts
import NewsletterContracts
public import NewsletterDomain

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
        public let campaignKey: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let status: Subscriber.Status
        public init(
            campaignKey: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            status: Subscriber.Status = .subscribed
        ) {
            self.campaignKey = campaignKey
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
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { throw Error.campaignNotFound }
            let value = try Subscriber.create(
                newsletterId: campaign.id,
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

    public enum Error: UseCaseError { case campaignNotFound }
}
