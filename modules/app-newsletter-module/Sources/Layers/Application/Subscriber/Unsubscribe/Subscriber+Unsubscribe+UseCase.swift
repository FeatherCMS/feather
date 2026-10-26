public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

import struct Foundation.Date

extension Subscriber.Unsubscribe {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>

        public init(
            transaction: any TransactionExecutor<Scope>
        ) {
            self.transaction = transaction
        }

        public func execute(
            input: Input
        ) async throws -> Output {
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
                        unsubscribeToken: input.token
                    )
                else {
                    throw Error(message: "Newsletter subscriber not found")
                }

                model.unsubscribe(at: now)
                return .init(model: try await scope.subscriber.update(model))
            }
        }
    }
}
