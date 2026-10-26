public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Subscriber.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }
        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await transaction.run { scope in
                guard
                    let campaign = try await scope.newsletter.findBy(
                        key: input.campaignKey
                    )
                else { throw Error.campaignNotFound }
                let keys = try await scope.subscriber.delete(
                    newsletterId: campaign.id,
                    emails: input.emails
                )
                return .init(keys: keys)
            }
        }
    }
}
