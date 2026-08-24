import FeatherApplication
import FeatherContracts
import Foundation
import NewsletterContracts
import NewsletterDomain

public struct UpdateIssue: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.update }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let subject: String
        public let content: String
        public let scheduledDate: Date?

        public init(
            id: String,
            subject: String,
            content: String,
            scheduledDate: Date?
        ) {
            self.id = id
            self.subject = subject
            self.content = content
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
        return try await transaction.run { scope in
            guard var issue = try await scope.issue.findBy(id: input.id)
            else {
                throw Error.notFound
            }
            guard !input.subject.isEmpty else {
                throw Issue.Error.subjectTooShort
            }
            guard input.subject.count < 255 else {
                throw Issue.Error.subjectTooLong
            }
            guard !input.content.isEmpty else {
                throw Issue.Error.contentTooShort
            }
            issue.subject = input.subject
            issue.content = input.content
            issue.scheduledDate = input.scheduledDate
            issue.status = input.scheduledDate == nil ? .draft : .scheduled
            return (try await scope.issue.update(issue)).asDetail
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
