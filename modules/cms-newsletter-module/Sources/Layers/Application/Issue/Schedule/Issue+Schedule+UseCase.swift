public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsletterDomain
public import NewsletterModule

extension Issue.Schedule {
    public struct UseCase: FeatherApplication.UseCase {

        let transaction: any TransactionExecutor<Scope>
        let authorizer: any Authorizer

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
