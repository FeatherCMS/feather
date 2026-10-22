public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Issue.Schedule {
public struct UseCase: FeatherApplication.UseCase {

    let transaction: any TransactionExecutor<Issue.Schedule.Scope>
    let authorizer: any Authorizer

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Issue.Schedule.Scope>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Issue.Schedule.Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let now = Date()
        return try await transaction.run { scope in
            guard var model = try await scope.issue.findBy(id: input.id)
            else {
                throw Error(message: "Newsletter issue not found")
            }

            try model.schedule(at: input.scheduledDate, now: now)
            return .init(model: try await scope.issue.update(model))
        }
    }
}
}
