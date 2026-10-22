public import FeatherApplication
public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

import struct Foundation.Date

extension Subscriber.Add {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Subscriber.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Subscriber.Add.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Subscriber.Add.Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let now = Date()
            return try await transaction.run { scope in
                guard
                    let campaign = try await scope.newsletter.findBy(
                        key: input.campaignKey
                    )
                else { throw Error.campaignNotFound }
                let value = try Subscriber.Model.create(
                    newsletterId: campaign.id,
                    email: input.email,
                    subscriptionDate: now,
                    firstName: input.firstName,
                    lastName: input.lastName
                )
                if input.status == .unsubscribed {
                    var model = try await scope.subscriber.insert(value)
                    model.unsubscribe(at: now)
                    return .init(
                        model: try await scope.subscriber.update(model)
                    )
                }
                return .init(model: try await scope.subscriber.insert(value))
            }
        }

    }
}
