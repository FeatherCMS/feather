public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

import struct Foundation.Date

extension Subscriber.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Subscriber.Edit.Scope>
        let authorizer: any Authorizer

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Subscriber.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Subscriber.Edit.Output {
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
                else { throw Error(message: "Newsletter campaign not found") }
                guard
                    var model = try await scope.subscriber.findBy(
                        newsletterId: campaign.id,
                        email: input.email
                    )
                else { throw Error(message: "Newsletter subscriber not found") }
                model.update(
                    firstName: input.firstName,
                    lastName: input.lastName,
                    status: input.status,
                    at: now
                )
                return .init(model: try await scope.subscriber.update(model))
            }
        }
    }
}
