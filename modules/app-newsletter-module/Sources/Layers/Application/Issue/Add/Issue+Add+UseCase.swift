public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Issue.Add {
public struct UseCase: FeatherApplication.UseCase {
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Issue.Add.Scope>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Issue.Add.Scope>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Issue.Add.Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { throw Error.campaignNotFound }
            let model = try Issue.Model.create(
                newsletterId: campaign.id,
                subject: input.subject,
                previewText: input.previewText,
                content: input.content
            )
            return .init(model: try await scope.issue.insert(model))
        }
    }
}
}
