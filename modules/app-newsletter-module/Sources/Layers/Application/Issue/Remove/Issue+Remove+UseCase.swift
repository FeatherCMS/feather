public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
import NewsletterModule

extension Issue.Remove {
public struct UseCase: FeatherApplication.UseCase {
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Issue.Remove.Scope>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Issue.Remove.Scope>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { return .init(ids: []) }
            var ids: [String] = []
            for id in input.ids {
                guard
                    let issue = try await scope.issue.findBy(id: id),
                    issue.newsletterId == campaign.id
                else { continue }
                ids.append(id)
            }
            for id in ids {
                try await scope.delivery.delete(issueId: id)
            }
            return .init(ids: try await scope.issue.delete(ids: ids))
        }
    }
}
}
