public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Issue.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Issue.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Issue.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Issue.Edit.Output {
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
                else {
                    throw Error.notFound
                }
                guard
                    var issue = try await scope.issue.findBy(id: input.id),
                    issue.newsletterId == campaign.id
                else {
                    throw Error.notFound
                }
                try issue.update(
                    subject: input.subject,
                    content: input.content,
                    scheduledDate: input.scheduledDate
                )
                return .init(model: try await scope.issue.update(issue))
            }
        }
    }
}
