public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Delivery.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Delivery.List.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Delivery.List.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> [Delivery.List.Output] {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await transaction.run { scope in
                guard
                    let campaign = try await scope.newsletter.findBy(
                        key: input.campaignKey
                    ),
                    let issue = try await scope.issue.findBy(id: input.issueId),
                    issue.newsletterId == campaign.id
                else { throw Error.notFound }
                return try await scope.delivery.list(issueId: input.issueId)
                    .map(Delivery.List.Output.init(model:))
            }
        }

    }
}
