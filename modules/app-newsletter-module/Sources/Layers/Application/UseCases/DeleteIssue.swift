import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct DeleteIssue: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.delete }
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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        try await transaction.run { scope in
            let deleted = try await scope.issue.delete(ids: input.ids)
            guard !deleted.isEmpty else {
                throw Error.notFound
            }
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
