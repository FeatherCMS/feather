import NewsletterContracts
import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsletterDomain

import struct Foundation.Date

public struct ScheduleIssue: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.update }
    struct Error: UseCaseError {
        let message: String
    }

    let transaction: any TransactionExecutor<Write>
    let authorizer: any Authorizer

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let scheduledDate: Date

        public init(
            id: String,
            scheduledDate: Date
        ) {
            self.id = id
            self.scheduledDate = scheduledDate
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> IssueDetail {
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
            return (try await scope.issue.update(model)).asDetail
        }
    }
}
