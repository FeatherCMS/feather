import FeatherApplication
import FeatherContracts
import NewsletterDomain

public struct GetIssue: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.read }
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

        public init(id: String) {
            self.id = id
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
            guard let issue = try await scope.issue.findBy(id: input.id)
            else {
                throw Error.notFound
            }
            return issue.asDetail
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
