public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

import struct Foundation.Date

extension Subscriber.Subscribe {
    public struct UseCase: FeatherApplication.UseCase {
    let transaction: any TransactionExecutor<Subscriber.Subscribe.Scope>

    public init(
        transaction: any TransactionExecutor<Subscriber.Subscribe.Scope>
    ) {
        self.transaction = transaction
    }

    public func execute(
        input: Input
    ) async throws -> Subscriber.Subscribe.Output {
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
                return .init(model: try await scope.subscriber.update(model))
            }

            let newModel = try Subscriber.Model.create(
                newsletterId: campaign.id,
                email: input.email,
                subscriptionDate: now,
                firstName: input.firstName,
                lastName: input.lastName,
                unsubscribeToken: input.unsubscribeToken,
                source: input.source
            )
            return .init(model: try await scope.subscriber.insert(newModel))
        }
    }

    }
}
