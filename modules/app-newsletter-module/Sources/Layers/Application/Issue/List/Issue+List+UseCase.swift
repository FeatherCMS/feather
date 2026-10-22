public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Issue.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Issue.List.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Issue.List.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> [Issue.List.Output] {
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
                return try await scope.issue.list(newsletterId: campaign.id)
                    .map(Issue.List.Output.init(model:))
            }
        }
    }
}
